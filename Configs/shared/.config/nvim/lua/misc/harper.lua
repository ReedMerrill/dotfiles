-- every Harper suggestion in a buffer, in the quickfix list.
-- the list rebuilds itself as diagnostics change, and resolving the current
-- entry with s (or z=) jumps straight to the next one.
local M = {}

local TITLE = "Harper suggestions"
local group = vim.api.nvim_create_augroup("harper-qf", { clear = true })
local state = { qf_id = nil, bufnr = nil, gen = 0, pending = nil, timer = nil }

-- squash the code action titles into one line: replacements first, then the rest
local function summarize(actions)
	local seen, words, dicts, rest = {}, {}, {}, {}
	for _, action in ipairs(actions) do
		local title = action.title
		-- overlapping lints on one span repeat the same actions
		if not seen[title] then
			seen[title] = true
			local word = title:match("^Replace with: (.*)$")
			local dict = title:match("^Add .- to the (%w+) dictionary")
			if word then
				table.insert(words, word)
			elseif dict then
				table.insert(dicts, dict)
			elseif title:match("^Ignore") then
				table.insert(rest, "ignore")
			else
				table.insert(rest, (title:gsub("%.$", "")))
			end
		end
	end
	if #dicts > 0 then
		table.insert(rest, "add to " .. table.concat(dicts, "/") .. " dictionary")
	end
	local parts = {}
	if #words > 0 then
		table.insert(parts, table.concat(words, " "))
	end
	vim.list_extend(parts, rest)
	return table.concat(parts, " · ")
end

-- ask Harper for the code actions on every diagnostic, then hand back qf items
local function collect(bufnr, callback)
	local client = vim.lsp.get_clients({ bufnr = bufnr, name = "harper_ls" })[1]
	if not client then
		return callback(nil)
	end
	local diags = vim.diagnostic.get(bufnr, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
	table.sort(diags, function(a, b)
		return a.lnum < b.lnum or (a.lnum == b.lnum and a.col < b.col)
	end)

	local items, remaining = {}, #diags
	if remaining == 0 then
		return callback(items)
	end
	local function done(i, actions)
		local d = diags[i]
		items[i] = {
			bufnr = bufnr,
			lnum = d.lnum + 1,
			col = d.col + 1,
			end_lnum = d.end_lnum + 1,
			end_col = d.end_col + 1,
			text = d.message .. " → " .. summarize(actions or {}),
			-- identifies the entry across rebuilds
			user_data = ("%d:%d:%s"):format(d.lnum, d.col, d.message),
		}
		remaining = remaining - 1
		if remaining == 0 then
			callback(items)
		end
	end

	for i, d in ipairs(diags) do
		local params = {
			textDocument = vim.lsp.util.make_text_document_params(bufnr),
			range = d.user_data.lsp.range,
			context = {
				diagnostics = { d.user_data.lsp },
				triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
			},
		}
		local sent = client:request("textDocument/codeAction", params, function(_, result)
			done(i, result)
		end, bufnr)
		if not sent then
			done(i, nil)
		end
	end
end

-- the Harper list, but only while it's the current quickfix list
local function current_list()
	if not state.qf_id then
		return nil
	end
	local list = vim.fn.getqflist({ id = 0, idx = 0, items = 0 })
	if list.id == state.qf_id then
		return list
	end
end

local function refresh()
	local list = current_list()
	if not list then
		return
	end
	state.gen = state.gen + 1
	local gen = state.gen
	local old = list.items[list.idx]

	collect(state.bufnr, function(items)
		-- a newer refresh is on its way, or the list got replaced
		if not items or gen ~= state.gen or not current_list() then
			return
		end

		local idx, resolved = 1, old ~= nil
		for i, item in ipairs(items) do
			if old and item.user_data == old.user_data then
				idx, resolved = i, false
				break
			end
		end
		if resolved then
			-- the current entry is gone, so point at whatever came after it (wrapping)
			for i, item in ipairs(items) do
				if item.lnum > old.lnum or (item.lnum == old.lnum and item.col >= old.col) then
					idx = i
					break
				end
			end
		end

		local advance = resolved and state.pending == old.user_data
		state.pending = nil
		vim.fn.setqflist({}, "r", { id = state.qf_id, title = TITLE, items = items, idx = idx })
		if advance then
			if #items == 0 then
				vim.notify("Harper: all suggestions resolved")
			else
				pcall(vim.cmd.cc, idx)
			end
		end
	end)
end

-- diagnostics come in bursts while editing
local function schedule_refresh()
	state.timer = state.timer or vim.uv.new_timer()
	state.timer:stop()
	state.timer:start(150, 0, vim.schedule_wrap(refresh))
end

-- fill the quickfix list with every suggestion in the buffer and go to the first
function M.populate()
	local bufnr = vim.api.nvim_get_current_buf()
	collect(bufnr, function(items)
		if not items then
			return vim.notify("harper_ls isn't attached to this buffer", vim.log.levels.WARN)
		end
		if #items == 0 then
			return vim.notify("Harper: nothing to fix")
		end

		-- reuse our list instead of piling new ones onto the quickfix stack
		vim.fn.setqflist({}, current_list() and "r" or " ", { title = TITLE, items = items })
		state.qf_id = vim.fn.getqflist({ id = 0 }).id
		state.bufnr = bufnr
		state.pending = nil

		vim.api.nvim_clear_autocmds({ group = group })
		vim.api.nvim_create_autocmd("DiagnosticChanged", {
			group = group,
			buffer = bufnr,
			callback = schedule_refresh,
		})

		vim.cmd("copen | wincmd p | cc 1")
	end)
end

-- s/z=, plus: if the cursor is on the current Harper entry, move on to the next
-- entry once this one is resolved
function M.code_action()
	local list = current_list()
	local item = list and list.items[list.idx]
	if item and item.bufnr == vim.api.nvim_get_current_buf() and item.lnum == vim.fn.line(".") then
		state.pending = item.user_data
	end
	vim.lsp.buf.code_action()
end

return M

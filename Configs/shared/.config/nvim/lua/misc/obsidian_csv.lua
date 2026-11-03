-- obsidian.nvim treats [[data.csv]] as a link to a note, so following it offers
-- to create a note called "data.csv". This patches link following (<CR>, gd,
-- :Obsidian follow_link) and maps gf so CSV/TSV links open the file with :CsvViewEnable.
local M = {}

local group = vim.api.nvim_create_augroup("obsidian-csv", { clear = true })
-- files a link just resolved to, waiting to be opened
local expected = {}
local patched = false

local function is_table(path)
	local lower = path:lower()
	return vim.endswith(lower, ".csv") or vim.endswith(lower, ".tsv")
end

local function realpath(path)
	return vim.uv.fs_realpath(path) or path
end

-- next to the note or at the vault root (obsidian's own lookup), otherwise
-- anywhere in the vault, the way Obsidian resolves [[name.csv]]
local function resolve(location)
	location = vim.uri_decode(location) or location
	-- obsidian's lookup falls back to the closest *note*, so only trust it when
	-- it lands on the table itself
	local path = require("obsidian.link").resolve_link_path(location)
	if path and is_table(path) then
		return path
	end
	local note = vim.api.nvim_buf_get_name(0)
	local root = tostring(require("obsidian.api").resolve_workspace_dir(note ~= "" and note or nil))
	return vim.fs.find(function(name, dir)
		return vim.endswith(dir .. "/" .. name, "/" .. location)
	end, { path = root, type = "file", limit = 1 })[1]
end

-- the CSV/TSV target of a link, if that's what it points at
local function table_target(link)
	local ref = link and require("obsidian.parse.refs").parse(link)
	if not ref or ref.kind == "footnote" or not is_table(ref.target) then
		return nil
	end
	if require("obsidian.uri").is_uri(ref.target) then
		return nil
	end
	return ref.target
end

-- let obsidian (or gf) open the file however it likes, then turn csvview on
local function expect(path)
	expected[realpath(path)] = true
end

vim.api.nvim_create_autocmd("BufEnter", {
	group = group,
	pattern = { "*.csv", "*.tsv" },
	callback = function(ev)
		local path = realpath(vim.api.nvim_buf_get_name(ev.buf))
		if expected[path] then
			expected[path] = nil
			vim.cmd("CsvViewEnable")
		end
	end,
})

function M.patch()
	if patched then
		return
	end
	patched = true

	-- <CR> (smart action), :Obsidian follow_link and obsidian-ls's gd all end up here
	local definition = require("obsidian.lsp.handlers._definition")
	local follow_link = definition.follow_link
	definition.follow_link = function(link, callback, opts)
		local target = table_target(link)
		if not target then
			return follow_link(link, callback, opts)
		end
		local path = resolve(target)
		if not path then
			vim.notify(("Obsidian: couldn't find %s in the vault"):format(target), vim.log.levels.WARN)
			return callback(nil, {})
		end
		expect(path)
		local start = { line = 0, character = 0 }
		callback(nil, { { uri = vim.uri_from_fname(path), range = { start = start, ["end"] = start } } })
	end

	-- gf: obsidian's includeexpr has the same note fallback, and gf skips it
	-- entirely when the file happens to be relative to the cwd
	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		pattern = "*.md",
		callback = function(ev)
			vim.keymap.set("n", "gf", function()
				-- checked here rather than when mapping, since obsidian marks the
				-- buffer in its own BufEnter
				local target = vim.b.obsidian_buffer and table_target(require("obsidian.api").cursor_link())
				if not target then
					return "gf"
				end
				local path = resolve(target)
				if not path then
					vim.notify(("Obsidian: couldn't find %s in the vault"):format(target), vim.log.levels.WARN)
					return ""
				end
				expect(path)
				return "<cmd>edit " .. vim.fn.fnameescape(path) .. "<cr>"
			end, { buffer = ev.buf, expr = true, desc = "Go to file (CSV links open in csvview)" })
		end,
	})
end

return M

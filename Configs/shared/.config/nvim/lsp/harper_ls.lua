-- spelling + grammar for prose. Markdown only, so it stays out of code.

-- Folders where Harper should never start (this directory and everything under it)
local excluded_dirs = {
	"/Users/reed/Can. Mun. Barometer Dropbox/Reed Merrill/3-resources/obsidian/CMB",
}

local function is_excluded(path)
	path = vim.fs.normalize(vim.uv.fs_realpath(path) or path)
	for _, dir in ipairs(excluded_dirs) do
		dir = vim.fs.normalize(vim.uv.fs_realpath(dir) or dir)
		-- trailing slash so ".../CMB" doesn't also match ".../CMB-old"
		if path == dir or vim.startswith(path, dir .. "/") then
			return true
		end
	end
	return false
end

local root_markers = { ".harper-dictionary.txt", ".obsidian", ".git" }

return {
	filetypes = { "markdown" },
	-- an Obsidian vault is its own workspace, so each book gets its own
	-- dictionary for character/place names (.harper-dictionary.txt in the vault).
	-- Not calling on_dir keeps the server from starting for excluded folders.
	root_dir = function(bufnr, on_dir)
		local name = vim.api.nvim_buf_get_name(bufnr)
		if name == "" or is_excluded(name) then
			return
		end
		on_dir(vim.fs.root(bufnr, root_markers) or vim.fs.dirname(name))
	end,
	settings = {
		["harper-ls"] = {
			dialect = "Canadian",
			workspaceDictPath = ".harper-dictionary.txt",
		},
	},
	on_attach = function(_, bufnr)
		-- Harper handles spelling here; built-in spell would double-flag
		vim.wo.spell = false
		local harper = require("misc.harper")
		-- s opens Harper's suggestions (fixes, add to dictionary); built-in s is still `cl`.
		-- z= does the same, for spell muscle memory
		vim.keymap.set("n", "s", harper.code_action, { buffer = bufnr, desc = "Spelling/grammar fixes (Harper)" })
		vim.keymap.set("n", "z=", harper.code_action, { buffer = bufnr, desc = "Spelling/grammar fixes (Harper)" })
		-- zq puts all of them in the quickfix list; ]q/[q to walk it, s to fix
		vim.keymap.set("n", "zq", harper.populate, { buffer = bufnr, desc = "All Harper suggestions to quickfix" })
	end,
}

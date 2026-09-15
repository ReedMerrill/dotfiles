-- nvim-treesitter `main` only installs parsers and queries; highlighting, folds and
-- indentation are enabled per buffer below. Parser builds need `tree-sitter-cli`
-- (brew install tree-sitter-cli) and a C compiler.
local ensure_installed = {
	"lua",
	"vim",
	"vimdoc",
	"query",
	"markdown",
	"markdown_inline",
	"bash",
	"css",
	"c_sharp",
	"csv",
	"html",
	"javascript",
	"json",
	"python",
	"r",
	"regex",
	"rnoweb",
	"rust",
	"typescript",
	"yaml",
}

-- skip treesitter highlighting for large files
local max_filesize = 100 * 1024 -- 100 KB

---@param buf integer
---@param lang string
local function attach(buf, lang)
	if not vim.api.nvim_buf_is_valid(buf) or not vim.treesitter.language.add(lang) then
		return
	end

	local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
	if not (ok and stats and stats.size > max_filesize) then
		vim.treesitter.start(buf, lang)
	end

	if vim.treesitter.query.get(lang, "indents") then
		vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		ts.install(ensure_installed)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter-attach", { clear = true }),
			callback = function(args)
				local lang = vim.treesitter.language.get_lang(args.match)
				if not lang then
					return
				end

				-- automatically install missing parsers when entering a buffer
				if
					not vim.list_contains(ts.get_installed("parsers"), lang)
					and vim.list_contains(ts.get_available(), lang)
				then
					ts.install(lang):await(function(err)
						if not err then
							vim.schedule(function()
								attach(args.buf, lang)
							end)
						end
					end)
					return
				end

				attach(args.buf, lang)
			end,
		})
	end,
}

return {
	"sainnhe/gruvbox-material",
	lazy = false,
	priority = 1000,
	config = function()
		-- Optionally configure and load the colorscheme
		-- directly inside the plugin declaration.
		vim.g.gruvbox_material_enable_italic = true
		vim.g.gruvbox_material_background = "hard"
		-- Make the current line slightly darker than the default bg (#1d2021).
		-- Done in a ColorScheme autocmd so it survives colorscheme reloads.
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "gruvbox-material",
			callback = function()
				vim.api.nvim_set_hl(0, "CursorLine", { bg = "#161819" })
			end,
		})
		vim.cmd.colorscheme("gruvbox-material")
	end,
}

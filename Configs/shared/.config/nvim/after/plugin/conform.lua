require("conform").setup({
	formatters_by_ft = {
		csharp = { "csharpier" },
		html = { "prettier" },
		javascript = { "prettier" },
		json = { "prettier" },
		lua = { "stylua" },
		markdown = { "prettier" },
		python = { "ruff" },
		r = { "air" },
		sql = { "sqruff" },
		quarto = { "injected" },
	},
})

require("conform").setup({
	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 1000, lsp_format = "fallback" }
	end,
})

require("conform").formatters.injected = {
	-- Set the options field
	options = {
		-- Set to true to ignore errors
		ignore_errors = false,
		-- Map of treesitter language to file extension
		-- A temporary file name with this extension will be generated during formatting
		-- because some formatters care about the filename.
		lang_to_ext = {
			bash = "sh",
			javascript = "js",
			markdown = "md",
			python = "py",
			r = "r",
			typescript = "ts",
		},
	},
}

-- commands to turn the formatter on and off
vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})

vim.keymap.set("", "<leader>fm", function()
	require("conform").format({ async = true, lsp_fallback = true })
end)

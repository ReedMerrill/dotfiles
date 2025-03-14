require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		r = { "styler" },
		javascript = { "prettier" },
		html = { "prettier" },
		markdown = { "prettier" },
	},
})

require("conform").setup({
	format_on_save = function(bufnr)
		-- Disable with a global or buffer-local variable
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		-- A very big timeout because styler is like a turtle
		return { timeout_ms = 60000, lsp_format = "fallback" }
	end,
})

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

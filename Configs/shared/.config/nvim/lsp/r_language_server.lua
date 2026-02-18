return {
	on_attach = function()
		print("r_language_server attached")
	end,
	filetypes = { "r", "rmd", "quarto" },
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, ".git") or vim.uv.os_homedir())
	end,
}

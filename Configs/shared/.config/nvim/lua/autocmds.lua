-- set color column to be blank whenever wrap is set
vim.api.nvim_create_autocmd("BufEnter", {
	-- call on every file type
	pattern = "*",
	callback = function()
		local wrapped_fts = { "markdown", "quarto", "txt" }
		local ft = vim.api.nvim_get_option_value("filetype", {})
		for _, value in pairs(wrapped_fts) do
			-- check if ft is in wrapped_fts
			if value == ft then
				-- set colorcolumn to be blank
				vim.opt.colorcolumn = ""
			end
		end
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	command = "TSBufEnable highlight",
})

vim.api.nvim_create_autocmd("TermOpen", {
	command = "setlocal nospell",
})

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- enter insert mode when focusing a terminal
vim.api.nvim_create_autocmd("BufEnter", {
	desc = "Set terminal to insert mode",
	group = termgroup,
	pattern = "term://*",
	callback = function()
		vim.schedule(function()
			vim.cmd(":startinsert")
		end)
	end,
})

-- cursorline on for the current buffer only
vim.api.nvim_create_autocmd("WinEnter", {
	desc = "Turn on the cursorline when entering a buffer",
	callback = function()
		vim.opt.cursorline = true
	end,
})

vim.api.nvim_create_autocmd("WinLeave", {
	desc = "Turn on the cursorline when entering a buffer",
	callback = function()
		vim.opt.cursorline = false
	end,
})

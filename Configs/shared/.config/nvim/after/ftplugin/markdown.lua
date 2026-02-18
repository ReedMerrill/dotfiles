vim.opt.linebreak = true
vim.opt.wrap = true

vim.keymap.set("n", "<leader>at", "<cmd>AerialToggle!<CR>", { desc = "Toggle outline" })
vim.keymap.set("n", "<leader>ty", function()
	vim.cmd([[:normal! qaq]])
	vim.cmd([[:g/^\s*-\s□/normal! "Ayy]])
end, { desc = "Yank all to do list items to register a" })

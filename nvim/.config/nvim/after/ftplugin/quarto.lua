vim.opt.linebreak = true
vim.opt.wrap = true

-- render quarto document
vim.api.nvim_set_keymap("n", "<leader>qr", "<Cmd>quarto render %<CR>", { noremap = true })

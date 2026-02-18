vim.opt.linebreak = true
vim.opt.wrap = true

-- assignment operator insertion
vim.api.nvim_set_keymap("i", "<C-j>", " <- ", { noremap = true })
-- pipe operator insertion
vim.api.nvim_set_keymap("i", "<C-k>", " |>", { noremap = true })
-- membership operator insertion
vim.api.nvim_set_keymap("i", "<C-l>", "%in%", { noremap = true })

vim.keymap.set("n", "<leader>at", "<cmd>AerialToggle!<CR>", { desc = "Toggle outline" })

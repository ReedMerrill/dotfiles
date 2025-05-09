-- indentation and format
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- assignment operator insertion
vim.api.nvim_set_keymap("i", "<C-j>", " <- ", { noremap = true })
-- pipe operator insertion
vim.api.nvim_set_keymap("i", "<C-k>", " |>", { noremap = true })
-- membership operator insertion
vim.api.nvim_set_keymap("i", "<C-l>", "%in%", { noremap = true })

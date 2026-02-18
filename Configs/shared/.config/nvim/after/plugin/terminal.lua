-- set snacks.terminal toggle keymap here, because it doesn't override the default tag stack command when set in the snacks init
vim.keymap.set("n", "<leader>T", ":ToggleTerm direction=horizontal<CR>", { desc = "Toggle Terminal (Horiz.)" })
vim.keymap.set("n", "<leader>Tv", ":ToggleTerm direction=vertical<CR>", { desc = "Toggle Terminal (Vert.)" })

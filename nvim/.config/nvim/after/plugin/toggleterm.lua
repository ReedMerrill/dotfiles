-- open/toggle terminal
vim.keymap.set("n", "<leader>t", "<CMD>ToggleTerm<CR>", { desc = "Open a terminal" })
vim.keymap.set("n", "<leader>tv", "<CMD>ToggleTerm direction=vertical size=100<CR>", { desc = "Open a terminal" })

-- source r file
vim.keymap.set("n", "<leader>s", 'TermExec cmd="Rscript %"', { desc = "Source R script" })

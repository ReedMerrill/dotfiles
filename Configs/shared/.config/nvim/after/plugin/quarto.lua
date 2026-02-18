local runner = require("quarto.runner")
vim.keymap.set("n", "<leader>sc", runner.run_cell, { desc = "run cell", silent = true })
vim.keymap.set("n", "<leader>sa", runner.run_above, { desc = "run cell and above", silent = true })
vim.keymap.set("n", "<leader>sA", runner.run_all, { desc = "run all cells", silent = true })

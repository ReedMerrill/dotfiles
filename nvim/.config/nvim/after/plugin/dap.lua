require("dapui").setup()
require("nvim-dap-virtual-text").setup({ enabled = true, virt_text_pos = "inline" })
require("dap-python").setup()
vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "✋", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)

-- Debugger
vim.api.nvim_set_keymap("n", "<leader>dt", "<Cmd>lua require('dapui').toggle()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>bp", ":DapToggleBreakpoint<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dc", ":DapContinue<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dq", ":DapTerminate<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>i", ":DapStepInto<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>o", ":DapStepOver<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>oo", ":DapStepOut<CR>", { noremap = true })
-- reset dapui in case I closed some windows I want back, or zoomed in, etc...
vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require('dapui').open({reset = true})<CR>", { noremap = true })

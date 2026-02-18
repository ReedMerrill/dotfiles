require("nvim-dap-virtual-text").setup({ enabled = true, virt_text_pos = "inline" })
vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "✋", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)

require("dapui").setup()
Dapui_is_open = false
function toggle_dapui()
	local dapui = require("dapui")
	if Dapui_is_open then
		vim.keymap.del("n", "<leader>bp")
		vim.keymap.del("n", "<leader>dc")
		vim.keymap.del("n", "<leader>dq")
		vim.keymap.del("n", "<leader>dh")
		vim.keymap.del("n", "<leader>dj")
		vim.keymap.del("n", "<leader>dk")
		vim.keymap.del("n", "<leader>dl")
		vim.keymap.del("n", "<leader>dr")
		print("nvim-dap keymaps unset")
		Dapui_is_open = false
	else
		vim.api.nvim_set_keymap("n", "<leader>bp", ":DapToggleBreakpoint<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<leader>dc", ":DapContinue<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<leader>dq", ":DapTerminate<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<leader>dh", ":DapStepOut<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<leader>dj", ":DapStepOver<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<leader>dk", ":DapRestartFrame<CR>", { noremap = true })
		vim.api.nvim_set_keymap("n", "<leader>dl", ":DapStepInto<CR>", { noremap = true })
		-- reset dapui in case I closed some windows I want back, or zoomed in, etc...
		vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require('dapui').open({reset = true})<CR>", { noremap = true })
		print("nvim-dap keymaps set")
		Dapui_is_open = true
	end
	dapui.toggle()
end

vim.keymap.set("n", "<Leader>dt", toggle_dapui, { noremap = true, silent = true, desc = "Toggle DAP UI" })

-- OSV: neovim runtime debugging
vim.keymap.set("n", "<leader>do", function()
	require("osv").launch({ port = 8086 })
	print("OSV launched")
end, { noremap = true, desc = "Launch OSV" })

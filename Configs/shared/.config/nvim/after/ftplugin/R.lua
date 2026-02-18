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

-- R dev functions and keymaps

local testthat_term_buf = nil
local testthat_term_job_id = nil

local function run_r_testthat()
	-- If terminal buffer doesn't exist or is invalid, create it
	if not (testthat_term_buf and vim.api.nvim_buf_is_valid(testthat_term_buf)) then
		-- Open terminal in a vertical split
		vim.cmd("botright vsplit")
		vim.cmd("vertical resize 80") -- Adjust width as needed
		vim.cmd("terminal R -q")

		testthat_term_buf = vim.api.nvim_get_current_buf()
		testthat_term_job_id = vim.b.terminal_job_id
	else
		-- Reopen the terminal buffer
		vim.cmd("botright vsplit")
		vim.cmd("vertical resize 80")
		vim.api.nvim_set_current_buf(testthat_term_buf)
	end

	-- Send the command to the running R session
	if testthat_term_job_id then
		vim.fn.chansend(testthat_term_job_id, "testthat::test_local()\n")
	end

	-- Enter terminal mode
	vim.cmd("startinsert")
end

-- Create a Neovim command to call the function
vim.api.nvim_create_user_command("RunRTestAll", run_r_testthat, {})
vim.keymap.set("n", "<leader>rt", ":RunRTestAll<cr>", { desc = "Run all R Tests" })

vim.keymap.set("n", "<leader>ss", function()
	vim.cmd("SessionManager save_current_session")
	print("Current session saved")
end, { noremap = true, desc = "Save current session" })

vim.keymap.set("n", "<leader>so", ":SessionManager load_session<cr>", { noremap = true, desc = "Load session" })

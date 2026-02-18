-- install lazy.nvim if it isn't already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",

		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- set leader key
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- get nice colors
vim.opt.termguicolors = true

-- load plugins
require("lazy").setup("plugins")

-- load sets and remaps
require("keymaps")
require("opts")
require("autocmds")

-- for dev --------------------

-- print the contents of a lua table
P = function(v)
	print(vim.inspect(v))
	return v
end

-- source current file
vim.keymap.set("n", "<leader>lxx", function()
	vim.cmd("w")
	vim.cmd("source %")
	print("current lua file sourced")
end)

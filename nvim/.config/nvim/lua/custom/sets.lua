-- set leader to " "
vim.g.mapleader = " "

-- editor features
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "79"
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.timeoutlen = 300

-- indentation and format
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

-- backups
vim.opt.swapfile = true
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- search
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- get nice colors
vim.opt.termguicolors = true

-- 8 line padding during scrolling
vim.opt.scrolloff = 20

-- fast update time
vim.opt.updatetime = 50

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- disable Copilot for markdown and quarto
vim.g.copilot_filetypes = { markdown = false }
vim.g.copilot_filetypes = { quarto = false }

-- turn on spell checking. Ignores code.
-- keybindings:
-- ]s - next misspelled word
-- [s - previous misspelled word
-- z= - suggestions
-- 1 - use first suggestion
-- zg - add word to dictionary
vim.opt.spelllang = "en_us"
vim.opt.spell = true
-- disable spell checking for terminal windows
vim.cmd([[
  autocmd TermOpen * setlocal nospell
]])

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

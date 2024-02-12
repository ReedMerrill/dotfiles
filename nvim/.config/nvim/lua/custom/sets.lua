-- set leader to " "
vim.g.mapleader = " "

-- editor features
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "79"
vim.opt.cursorline = true

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
vim.opt.scrolloff = 8

-- fast update time
vim.opt.updatetime = 50

-- conceallevel (for live formatting in markdown etc...)
vim.opt.conceallevel = 2

-- disable perl
vim.g.loaded_perl_provider = 0

-- editor features
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "81"
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
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- search
vim.opt.hlsearch = true
vim.opt.incsearch = true
-- ignore case unless capital is in search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- limit terminal scrollback to avoid lag on old terminal sessions
vim.opt.scrollback = 2000

-- 8 line padding during scrolling
vim.opt.scrolloff = 20

-- fast update time
vim.opt.updatetime = 0

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

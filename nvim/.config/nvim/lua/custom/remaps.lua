-- utils

-- save and quit with leader
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true })
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true })
vim.keymap.set("n", "<leader>wq", ":wq<CR>", { noremap = true })
vim.keymap.set("n", "<leader>wa", ":wall<CR>", { noremap = true })

-- reload the buffer from last save
vim.keymap.set("n", "<leader>r", ":e!", { desc = "Reload buffer" })

-- code navigation

-- keep cursor in the same spot for "J"
vim.keymap.set("n", "J", "mzJ`z")

-- keep the cursor in the middle of the page when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep search terms in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- close the buffer, not the window (container)
vim.keymap.set("n", "<leader>c", "<cmd>bp<bar>bd#<cr>", { desc = "Close Current Buffer" })

-- editing

-- paste over a highlighted word w/o saving it to the register in visual mode
vim.keymap.set("x", "<leader>dp", [["_dP]])

-- yank to the system register in visual and normal modes
vim.keymap.set({ "n", "v", "x" }, "<leader>y", [["+y]])

-- make the file in buffer executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- move visual mode text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- buffer navigation

-- splits
vim.keymap.set({ "n", "i" }, "<c-k>", ":wincmd k<CR>", {})
vim.keymap.set({ "n", "i" }, "<c-j>", ":wincmd j<CR>", {})
vim.keymap.set({ "n", "i" }, "<c-h>", ":wincmd h<CR>", {})
vim.keymap.set({ "n", "i" }, "<c-l>", ":wincmd l<CR>", {})
-- make a new split
vim.keymap.set({ "n" }, "<leader>\\", ":vsplit<CR>", {})

-- Terminal
vim.keymap.set("t", "<C-t>", "<cmd>ToggleTerm<cr>", { desc = "Exit Terminal Mode" })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal Navigation" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal Navigation" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal Navigation" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal Navigation" })

-- open/toggle terminal
vim.keymap.set("n", "<C-t>", "<CMD>ToggleTerm<CR>", { desc = "Open a terminal" })
vim.keymap.set("n", "<C-t>v", "<CMD>ToggleTerm direction=vertical size=100<CR>", { desc = "Open a terminal" })

-- cycle through buffers
vim.keymap.set("n", "<leader><tab>", "<cmd>bnext<cr>", { noremap = true })

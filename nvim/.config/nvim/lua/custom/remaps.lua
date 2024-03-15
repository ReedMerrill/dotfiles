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

-- splits/navigation

-- make a new split
vim.keymap.set({ "n" }, "<leader>\\", ":vsplit<CR>", {})
vim.keymap.set({ "n" }, "<leader>\\a", ":split<CR>", {})

-- Terminal
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Terminal Navigation" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Terminal Navigation" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Terminal Navigation" })
-- this probably conflicts the tmux navigation stuff, but I never do because my
-- terminal is always on the left
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Terminal Navigation" })
-- Exit terminal mode
vim.keymap.set("t", "<C-t>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })

-- open/toggle terminal
vim.keymap.set("n", "<C-t>", "<CMD>ToggleTerm<CR>", { desc = "Open a terminal" })
vim.keymap.set("n", "<C-t>v", "<CMD>ToggleTerm direction=vertical size=100<CR>", { desc = "Open a terminal" })

-- go to previous buffer
-- cycle through open buffers
vim.keymap.set("n", "<leader>b", "<cmd>b#<cr>", { noremap = true })
vim.keymap.set("n", "<leader><tab>", "<cmd>bnext<cr>", { noremap = true })

-- save and quit with leader
vim.keymap.set("n", "<leader>w", ":w<CR>", { noremap = true })
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true })
vim.keymap.set("n", "<leader>wq", ":wq<CR>", { noremap = true })
vim.keymap.set("n", "<leader>wa", ":wall<CR>", { noremap = true })

-- move visual mode text up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor in the same spot for "J"
vim.keymap.set("n", "J", "mzJ`z")

-- keep the cursor in the middle of the page when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep search terms in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste over a highlighted word w/o saving it to the register in visual mode
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank to the system register in visual and normal modes
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])

-- make the file in buffer executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- splits
-- navigation
vim.keymap.set({ "n", "i" }, "<c-k>", ":wincmd k<CR>", {})
vim.keymap.set({ "n", "i" }, "<c-j>", ":wincmd j<CR>", {})
vim.keymap.set({ "n", "i" }, "<c-h>", ":wincmd h<CR>", {})
vim.keymap.set({ "n", "i" }, "<c-l>", ":wincmd l<CR>", {})
-- make a new split
vim.keymap.set({ "n" }, "<leader>\\", ":vsplit<CR>", {})

-- Terminal stuff
-- switch out of terminal mode
vim.keymap.set("t", "<ESC><ESC>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })
-- split nav
vim.keymap.set("t", "<C-h", "<C-w>h", { desc = "Terminal Navigation" })
vim.keymap.set("t", "<C-j", "<C-w>j", { desc = "Terminal Navigation" })
vim.keymap.set("t", "<C-k", "<C-w>k", { desc = "Terminal Navigation" })
vim.keymap.set("t", "<C-l", "<C-w>l", { desc = "Terminal Navigation" })

-- reload the buffer from last save
vim.keymap.set("n", "<leader>r", ":e!", { desc = "Reload buffer" })

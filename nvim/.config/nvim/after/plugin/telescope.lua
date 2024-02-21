local trouble = require("trouble.providers.telescope")

-- get ripgrep to stop ignoring hidden and gitignore files
require("telescope").setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--hidden",
		},
		-- send results to trouble's quickfix list
		mappings = {
			i = { ["<c-l>"] = trouble.open_with_trouble },
			n = { ["<c-l>"] = trouble.open_with_trouble },
		},
	},
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>p", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>ps", builtin.live_grep, { desc = "Grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Search Buffer" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search Help" })

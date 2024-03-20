return {
	{
		"windwp/nvim-ts-autotag",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	-- "gc" to comment visual regions/lines
	{ "numToStr/Comment.nvim", opts = {} },
	-- tokyonight theme
	{
		"folke/tokyonight.nvim",
		config = function()
			vim.cmd("colorscheme tokyonight-night")
		end,
	},
	-- plenary
	"nvim-lua/plenary.nvim",
	-- harpoon
	"ThePrimeagen/harpoon",
	-- undo tree
	"mbbill/undotree",
	-- smart splits
	"mrjones2014/smart-splits.nvim",
	-- word highlighting and cycling
	"RRethy/vim-illuminate",
	-- neovim (lua) dev stuff
	"folke/neodev.nvim",
	-- list of warnings, errors, and telescope outputs
	"folke/trouble.nvim",
	-- icons
	"nvim-tree/nvim-web-devicons",
}

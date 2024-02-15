return {
	-- tanagawa theme
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
	-- Icons for files and stuff
	"vnim-tree/nvim-web-devicons",
	-- list of warnings, errors, and telescope outputs
	"folke/trouble.nvim",
}

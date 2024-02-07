return {
    -- telescope
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.4',
		dependencies = { {'nvim-lua/plenary.nvim'} }
	},
    -- tanagawa theme
    {
        "folke/tokyonight.nvim",
        config = function()
            vim.cmd('colorscheme tokyonight-night')
        end
    },
	-- plenary
	"nvim-lua/plenary.nvim",
	-- harpoon
	"ThePrimeagen/harpoon",
	-- undo tree
	"mbbill/undotree",
    -- smart splits
    'mrjones2014/smart-splits.nvim',
}


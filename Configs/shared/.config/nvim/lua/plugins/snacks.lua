return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		dashboard = { enabled = true },
		explorer = { enabled = false },
		gitbrowse = { enable = true },
		indent = { animate = { enabled = false } },
		input = { enabled = true },
		lazygit = { enabled = true },
		notifier = { height = { min = 1, max = 0.6 }, width = { min = 1, max = 0.8 } },
		quickfile = { enabled = true },
		rename = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = true },
		terminal = { enabled = false },
		words = { enabled = true },
		zen = { ---@class snacks.zen.Config
			-- You can add any `Snacks.toggle` id here.
			-- Toggle state is restored when the window is closed.
			-- Toggle config options are NOT merged.
			---@type table<string, boolean>
			toggles = {
				dim = false,
				git_signs = true,
				mini_diff_signs = true,
				-- diagnostics = false,
				-- inlay_hints = false,
			},
			show = {
				statusline = false, -- can only be shown when using the global statusline
				tabline = false,
			},
			---@type snacks.win.Config
			win = {
				style = {
					enter = true,
					fixbuf = false,
					minimal = false,
					width = 120,
					height = 0,
					backdrop = { transparent = false, blend = 40 },
					keys = { q = false },
					zindex = 40,
					wo = {
						winhighlight = "NormalFloat:Normal",
					},
					w = {
						snacks_main = true,
					},
				},
			},
			--- Callback when the window is opened.
			---@param win snacks.win
			on_open = function(win) end,
			--- Callback when the window is closed.
			---@param win snacks.win
			on_close = function(win) end,
			--- Options for the `Snacks.zen.zoom()`
			---@type snacks.zen.Config
			zoom = {
				toggles = {},
				show = { statusline = true, tabline = true },
				win = {
					backdrop = false,
					width = 120,
				},
			},
		},
	},
	keys = {
		-- lazygit
		{
			"<leader>lg",
			function()
				Snacks.lazygit()
			end,
			desc = "Toggle lazygit",
		},
		-- scratch buffer
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle scratch buffer",
		},
		{
			"<leader>z",
			function()
				Snacks.zen()
			end,
			desc = "Toggle zen mode",
		},
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
			mode = { "n", "v" },
		},
	},
}

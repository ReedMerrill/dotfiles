return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				-- the full config defaults are in the repo, but it was outdated and I
				-- had to delete everything pertaining to the logger
				panel = {
					enabled = true,
					auto_refresh = false,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom", -- | top | left | right | horizontal | vertical
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					hide_during_completion = false,
					debounce = 15,
					trigger_on_accept = true,
					keymap = {
						accept = "<C-y>",
						accept_word = false,
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				filetypes = {
					-- Markdown is disabled by default
					yaml = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					csv = false,
				},
				auth_provider_url = nil, -- URL to authentication provider, if not "https://github.com/"

				copilot_node_command = "node", -- Node.js version must be > 20
				workspace_folders = {},
				copilot_model = "",
				root_dir = function()
					return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
				end,
				server = {
					type = "nodejs", -- "nodejs" | "binary"
					custom_server_filepath = nil,
				},
				server_opts_overrides = {},
			})
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
		dependencies = {
			"j-hui/fidget.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"ravitemer/codecompanion-history.nvim", -- Save and load conversation history
			{
				"zbirenbaum/copilot.lua",
				opts = { panel = { enabled = false } },
			},
			{
				"Davidyz/VectorCode", -- Index and search code in your repositories
				version = "*",
				build = "uv tool install vectorcode",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
			{
				"MeanderingProgrammer/render-markdown.nvim",
				ft = { "codecompanion" },
			},
		},
		opts = {
			picker = "snacks",
		},
		keys = {
			{
				"<leader>cc",
				function()
					vim.cmd("CodeCompanionChat toggle")
				end,
				desc = "Toggle AI Chat",
			},
		},
	},
}

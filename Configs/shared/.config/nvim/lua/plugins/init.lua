return {
	{
		"saghen/blink.cmp",
		version = "1.*",
		opts = {
			keymap = { preset = "default" },
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = { documentation = { auto_show = false } },
			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"quarto-dev/quarto-nvim",
		dependencies = {
			"jmbuhr/otter.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			debug = false,
			closePreviewOnExit = true,
			lspFeatures = {
				enabled = true,
				chunks = "curly",
				languages = { "r" },
				diagnostics = {
					enabled = false,
					triggers = { "BufWritePost" },
				},
				completion = {
					enabled = true,
				},
			},
			codeRunner = {
				enabled = true,
				default_method = "iron",
				never_run = { "yaml" },
			},
		},
	},
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	{
		"sindrets/diffview.nvim",
		opts = {
			default_args = { DiffviewOpen = { "--imply-local" } },
		},
	},
	{
		"nvim-mini/mini.diff", -- Inline and better diff over the default
		config = function()
			local diff = require("mini.diff")
			diff.setup({
				source = diff.gen_source.none(), -- Disabled by default
			})
		end,
	},
	{
		"catgoose/nvim-colorizer.lua",
		event = "BufReadPre",
		opts = {
			filetypes = { "*", "!csv", markdown = { names = false } },
		},
	},
	{
		"Shatur/neovim-session-manager",
		config = function()
			local config = require("session_manager.config")
			require("session_manager").setup({
				autoload_mode = { config.AutoloadMode.Disabled },
			})
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	-- add lua docs to the vim help pages
	{ "nanotee/luv-vimdocs" },
	-- winbar with path and symbols
	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			show_modified = true,
			show_navic = false,
			theme = {
				normal = { bg = "#1d2021", fg = "#DCD7BA" },
				basename = { bold = false },
			},
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = false,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = false, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
		},
	},
	{
		"geg2102/nvim-python-repl",
		dependencies = "nvim-treesitter",
		ft = { "python" },
		config = function()
			require("nvim-python-repl").setup({
				execute_on_send = true,
				vsplit = false,
			})
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				-- size can be a number or function which is passed the current terminal
				size = function(term)
					if term.direction == "horizontal" then
						return 15
					elseif term.direction == "vertical" then
						return vim.o.columns * 0.4
					end
				end,
			})
		end,
	},
	-- telescope (for LSP related pickers)
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	-- Debugger
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"jbyuki/one-small-step-for-vimkind",
		},
		lazy = false,
		config = function()
			local dap = require("dap")
			dap.configurations.lua = {
				{
					type = "nlua",
					request = "attach",
					name = "Attach to running Neovim instance",
				},
			}

			dap.adapters.nlua = function(callback, config)
				callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
			end
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
	},
	{ "HiPhish/debugpy.nvim" },
	{ "theHamsta/nvim-dap-virtual-text" },
	{ "HiPhish/rainbow-delimiters.nvim" },
	{
		"alexghergh/nvim-tmux-navigation",
		config = function()
			require("nvim-tmux-navigation").setup({ disable_when_zoomed = true })
		end,
	},
	{
		-- Use lualine for the status line
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					globalstatus = true,
					theme = "gruvbox-material",
					component_separators = "",
					section_separators = "",
				},
				sections = {
					lualine_a = {},
					lualine_c = {},
					lualine_x = {
						{
							function()
								local util = require("util")
								if util.is_tmux then
									local sess = util.tmux_session()
									local win = util.tmux_window()
									return (" %s: %s"):format(sess or "-", win or "-")
								end
								return ""
							end,
						},
					},
					lualine_y = { "encoding", "fileformat" },
					lualine_z = { "location" },
				},
			})
		end,
	},
	-- outlines for code and markdown
	{
		"stevearc/aerial.nvim",
		-- optional
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
	},
	{ "lewis6991/gitsigns.nvim", opts = {} },
	{ "akinsho/git-conflict.nvim", version = "*", config = true },
	-- formatting
	{ "stevearc/conform.nvim", opts = {} },
	{ "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>at",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>nh",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Show Notification History",
			},
		},
	},
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
	-- Tree-sitter auto HTML tags
	{
		"windwp/nvim-ts-autotag",
		opts = {},
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		opts = {},
	},
	-- plenary
	"nvim-lua/plenary.nvim",
	-- harpoon
	"ThePrimeagen/harpoon",
	-- neovim dev stuff for lua
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	-- icons
	"nvim-tree/nvim-web-devicons",
	-- better text objects
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = "nvim-treesitter/nvim-treesitter",
	},
	-- more "around" and "inside" actions
	{ "nvim-mini/mini.ai", opts = {}, version = false },
	-- Launch a live server
	-- {
	-- 	"barrett-ruth/live-server.nvim",
	-- 	build = "pnpm add -g live-server",
	-- 	cmd = { "LiveServerStart", "LiveServerStart" },
	-- 	config = true,
	-- 	keys = { { "<leader>L", "<cmd>LiveServerToggle<cr>" } },
	-- },
	{
		"hat0uma/csvview.nvim",
		---@module "csvview"
		---@type CsvView.Options
		opts = {
			parser = { comments = { "#", "//" } },
			keymaps = {
				-- Text objects for selecting fields
				textobject_field_inner = { "if", mode = { "o", "x" } },
				textobject_field_outer = { "af", mode = { "o", "x" } },
				-- Excel-like navigation:
				-- Use <Tab> and <S-Tab> to move horizontally between fields.
				-- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
				-- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
				jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
				jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
				jump_next_row = { "<Enter>", mode = { "n", "v" } },
				jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
			},
		},
		cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
	},
}

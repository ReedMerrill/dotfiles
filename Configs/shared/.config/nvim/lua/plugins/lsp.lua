return {
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for neovim
			"folke/snacks.nvim",
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
		},
		config = function()
			local servers = {}
			local lsp_path = vim.fn.stdpath("config") .. "/lsp"
			if vim.fn.isdirectory(lsp_path) == 1 then
				for _, file in ipairs(vim.fn.readdir(lsp_path)) do
					if file:match("%.lua$") then
						local server_name = file:gsub("%.lua$", "")
						local success, config = pcall(dofile, lsp_path .. "/" .. file)
						if success then
							servers[server_name] = config
						else
							vim.notify(
								"Failed to load LSP config for " .. server_name .. ": " .. config,
								vim.log.levels.ERROR
							)
						end
					end
				end
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(ev)
					local map = function(keys, fn, desc)
						vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = desc })
					end
					local Snacks = require("snacks")

					map("gd", function()
						Snacks.picker.lsp_definitions()
					end, "Goto Definition")
					map("gD", function()
						Snacks.picker.lsp_declarations()
					end, "Goto Declaration")
					-- NOTE: `grr` and not `gr`: neovim 0.11 ships `gr{a,i,n,r,t}` by
					-- default, so a bare `gr` map is ambiguous and stalls for
					-- 'timeoutlen' before firing.
					map("grr", function()
						Snacks.picker.lsp_references()
					end, "References")
					map("gri", function()
						Snacks.picker.lsp_implementations()
					end, "Goto Implementation")
					map("gy", function()
						Snacks.picker.lsp_type_definitions()
					end, "Goto Type Definition")
					map("gO", function()
						Snacks.picker.lsp_symbols()
					end, "Document Symbols")
					map("gW", function()
						Snacks.picker.lsp_workspace_symbols()
					end, "Workspace Symbols")

					map("grn", vim.lsp.buf.rename, "Rename")
					map("gra", vim.lsp.buf.code_action, "Code Action")
					map("K", vim.lsp.buf.hover, "Hover")
				end,
			})

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP Specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			--  NOTE: blink.cmp handles this automatically in Neovim 0.11+ when using vim.lsp.config
			vim.lsp.config("*", {
				capabilities = vim.lsp.protocol.make_client_capabilities(),
			})

			-- Register the configs from lsp/ before anything enables a server, so
			-- mason-lspconfig's automatic_enable picks up our settings.
			for server_name, config in pairs(servers) do
				vim.lsp.config(server_name, config)
			end

			-- Ensure the servers and tools above are installed
			require("mason").setup()

			-- NOTE: mason-lspconfig v2 dropped `handlers`. It enables every
			-- installed server itself via `automatic_enable` (on by default).
			require("mason-lspconfig").setup()

			-- Enable servers that have configs in lsp/ but aren't managed by Mason
			for server_name in pairs(servers) do
				vim.lsp.enable(server_name)
			end
		end,
	},
	-- WARN: This might not work below neovim 0.11
	{
		-- Diagnostics messages
		vim.diagnostic.config({
			signs = { priority = 9999 },
			underline = true,
			update_in_insert = false, -- false so diagnostics are updated on InsertLeave
			virtual_lines = { current_line = true },
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = true,
				header = "",
			},
		}),
	},
}

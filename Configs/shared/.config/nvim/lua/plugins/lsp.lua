return {
	{ -- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for neovim
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

			--  This function gets run when an LSP attaches to a particular buffer.
			--    That is to say, every time a new file is opened that is associated with
			--    an LSP (for example, opening `main.rs` is associated with `rust_analyzer`) this
			--    function will be executed to configure the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					-- In this case, we create a function that lets us more easily define mappings specific
					-- for LSP related items. It sets the mode, buffer and description for us each time.
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					-- LSP rename
					map("grn", vim.lsp.buf.rename, "LSP rename")
					-- Jump to the definition of the word under your cursor.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					-- Find references
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					-- Fuzzy find all the symbols in your current workspace
					--  Similar to document symbols, except searches over your whole project.
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
					-- WARN: This is not Goto Definition, this is Goto Declaration.
					map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
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

			-- Ensure the servers and tools above are installed
			require("mason").setup()

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local config = servers[server_name] or {}
						vim.lsp.config(server_name, config)
						vim.lsp.enable(server_name)
					end,
				},
			})

			-- Manually enable servers that might not be managed by Mason but have configs in lsp/
			for server_name, config in pairs(servers) do
				vim.lsp.config(server_name, config)
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

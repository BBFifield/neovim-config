local wk = require("which-key")

-- autocmd to execute the formatter when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

return {
	{
		"folke/neoconf.nvim",
		opts = {
			-- name of the local settings files
			local_settings = ".neoconf.json",
			-- name of the global settings file in your Neovim config directory
			global_settings = "neoconf.json",
			-- import existing settings from other plugins
			import = {
				vscode = true, -- local .vscode/settings.json
				nlsp = true, -- global/local nlsp-settings.nvim json settings
			},
			-- send new configuration to lsp clients when changing json settings
			live_reload = true,
			-- set the filetype to jsonc for settings files, so you can use comments
			-- make sure you have the jsonc treesitter parser installed!
			filetype_jsonc = true,
			plugins = {
				-- configures lsp clients with settings in the following order:
				-- - lua settings passed in lspconfig setup
				-- - global json settings
				-- - local json settings
				lspconfig = {
					enabled = true,
				},
				-- configures jsonls to get completion in .nvim.settings.json files
				jsonls = {
					enabled = true,
					-- only show completion in json settings for configured lsp servers
					configured_servers_only = true,
				},
				-- configures lua_ls to get completion of lspconfig server settings
				lua_ls = {
					-- by default, lua_ls annotations are only enabled in your neovim config directory
					enabled_for_neovim_config = true,
					-- explicitly enable adding annotations. Mostly relevant to put in your local .nvim.settings.json file
					enabled = false,
				},
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"antosha417/nvim-lsp-file-operations",
			"folke/neoconf.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local navic_enabled, navic = pcall(require, "nvim-navic")

			wk.add({
				{
					"<leader>li",
					"<cmd>:LspInfo<CR>",
					icon = "",
					desc = "Show status of active and configured language servers",
				},
			})

			local signs = { Error = "", Warn = "", Hint = "󰌶", Info = "" }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
				capabilities = vim.tbl_deep_extend(
					"force",
					vim.lsp.protocol.make_client_capabilities(),
					require("lsp-file-operations").default_capabilities(),
					require("blink.cmp").get_lsp_capabilities()
				),
				on_attach = function(client, bufnr)
					require("lsp-file-operations").setup()
					if client.server_capabilities.documentSymbolProvider then
						if navic_enabled then
							navic.attach(client, bufnr)
						end
					end
				end,
				flags = {
					debounce_text_changes = 150,
				},
			})

			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
			lspconfig.lua_ls.setup({
				on_init = function(client)
					local path = client.workspace_folders[1].name
					if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
						return
					end

					client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
						runtime = {
							-- Tell the language server which version of Lua you're using
							-- (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							globals = { "vim" },
							disable = { "trailing-space" },
						},
						-- Make the server aware of Neovim runtime files
						workspace = {
							checkThirdParty = false,
							library = {
								vim.env.VIMRUNTIME,
								-- Depending on the usage, you might want to add additional paths here.
								-- "${3rd}/luv/library"
								-- "${3rd}/busted/library",
							},
							-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
							-- library = vim.api.nvim_get_runtime_file("", true)
						},
					})
				end,
				settings = {
					Lua = {},
				},
			})
			lspconfig.rust_analyzer.setup({
				settings = {
					["rust-analyzer"] = {
						diagnostics = {
							enable = true,
						},
					},
				},
			})

			lspconfig.nil_ls.setup({})
		end,
	},
	{
		"stevearc/conform.nvim",
		enabled = function()
			return NewfieVim:get_plugin_info("lsp_config").enabled
		end,
		version = "*",
		opts = {
			formatters_by_ft = {
				nix = { "alejandra" },
				lua = { "stylua" },
				css = { "prettierd" },
				scss = { "prettierd" },
				rs = { "rustfmt" },
			},
			format_on_save = {
				-- I recommend these options. See :help conform.format for details.
				lsp_format = "fallback",
				timeout_ms = 5000,
			},
		},
		config = function(_, opts)
			require("conform").setup(opts)
			wk.add({
				{ "<leader>lf", "<cmd>lua vim.lsp.buf.format()<CR>", icon = "󰝔", desc = "Run formatter" },
			})
		end,
	},

	{
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
		{ -- optional blink completion source for require statements and module annotations
			"saghen/blink.cmp",
			lazy = false, -- lazy loading handled internally
			-- optional: provides snippets for the snippet source
			dependencies = "rafamadriz/friendly-snippets",
			version = "v0.7.6",
			--build = "nix run .#build-plugin",
			opts = {
				appearance = {
					-- Sets the fallback highlight groups to nvim-cmp's highlight groups
					-- Useful for when your theme doesn't support blink.cmp
					-- will be removed in a future release
					use_nvim_cmp_as_default = true,
					-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = "mono",
				},
				sources = {
					-- add lazydev to your completion providers
					default = { "lsp", "path", "snippets", "buffer", "lazydev" },
					providers = {
						-- dont show LuaLS require statements when lazydev has items
						lazydev = {
							name = "LazyDev",
							module = "lazydev.integrations.blink",
							fallbacks = { "lsp" },
						},
					},
				},
			},
		},
	},
}

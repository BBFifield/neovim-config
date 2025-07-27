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

			local severity = vim.diagnostic.severity
			local symbols = {
				[severity.ERROR] = "",
				[severity.WARN] = "",
				[severity.HINT] = "󰌶",
				[severity.INFO] = "",
			}

			local highlights = {
				[severity.ERROR] = "DiagnosticError",
				[severity.WARN] = "DiagnosticWarn",
				[severity.HINT] = "DiagnosticHint",
				[severity.INFO] = "DiagnosticInfo",
			}

			local signs = { text = {}, linehl = {}, numhl = {} }

			for level, symbol in pairs(symbols) do
				signs.text[level] = symbol
				-- signs.linehl[level] = highlights[level]
				signs.numhl[level] = highlights[level]
			end

			vim.diagnostic.config({ virtual_text = true, signs = signs })

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
			lspconfig.ts_ls.setup({})
			lspconfig.jsonls.setup({
				cmd = { "vscode-json-languageserver", "--stdio" },
				init_options = {
					provideFormatter = false,
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
			formatters = {
				prettierdcss = {
					command = "prettierd",
					args = {
						"--stdin-from-filename",
						"$FILENAME",
						"--print-width=200", --Don't new line long selectors
					},
					stdin = true,
					inherit = true,
				},
			},
			formatters_by_ft = {
				nix = { "alejandra" },
				lua = { "stylua" },
				css = { "prettierdcss" },
				scss = { "prettierd" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				json = { "prettierd" },
				rust = { "rustfmt" },
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
		"mfussenegger/nvim-lint",
		enabled = function()
			return NewfieVim:get_plugin_info("lsp_config").enabled
		end,
		opts = {
			events = { "BufWritePost", "BufReadPost" },
			linters_by_ft = {
				css = { "stylelint" },
			},
			linters = {
				stylelint = {
					stdin = false,
					args = {
						"--formatter",
						"json",
						"--config",
						vim.fn.expand("$HOME/.config/stylelint.config.js"),
						"$FILENAME",
					},
				},
			},
		},
		config = function(_, opts)
			local lint = require("lint")

			lint.linters_by_ft = opts.linters_by_ft

			for name, linter in pairs(opts.linters) do
				if type(linter) == "table" and type(lint.linters[name]) == "table" then
					lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
					if type(linter.prepend_args) == "table" then
						lint.linters[name].args = lint.linters[name].args or {}
						vim.list_extend(lint.linters[name].args, linter.prepend_args)
					end
				else
					lint.linters[name] = linter
				end
			end

			local function safe_timer_run(steps, interval)
				local timer, idx = vim.loop.new_timer(), 1
				if not timer then
					return
				end

				timer:start(
					0,
					interval,
					vim.schedule_wrap(function()
						local fn = steps[idx]
						if not fn then
							if timer then
								timer:stop()
								timer:close()
								timer = nil
							end
							return
						end

						fn()
						idx = idx + 1
					end)
				)
			end

			local function run_lint()
				local lint = require("lint")
				local fp = require("fidget.progress")
				local ft = vim.bo.filetype
				local linters = lint.linters_by_ft[ft] or {}
				if #linters == 0 then
					return
				end

				-- fire them all on the current buffer
				lint.try_lint()

				vim.defer_fn(
					vim.schedule_wrap(function()
						local running = lint.get_running()
						local active = {}
						for _, name in ipairs(linters) do
							if running[name] then
								table.insert(active, name)
							end
						end
						if #active == 0 then
							vim.list_extend(active, linters)
						end
						table.sort(active)

						local handle = fp.handle.create({
							key = "nvim_lint",
							title = "Linting " .. ft .. "…",
							spinner = "dots",
						})

						-- build descriptor-tables
						local descs = {
							{ title = "Scanning buffer…", pct = 10 },
						}
						for i, name in ipairs(active) do
							descs[#descs + 1] = {
								title = ("Running %s…"):format(name:sub(1, 1):upper() .. name:sub(2)),
								pct = math.floor(10 + (i / #active) * 80),
								linter = name,
							}
						end
						descs[#descs + 1] = { title = "Finalizing results…", pct = 95 }
						descs[#descs + 1] = { finish = true }

						-- wrap each descriptor into a function
						local fns = {}
						for _, d in ipairs(descs) do
							table.insert(fns, function()
								if d.finish then
									handle:finish()
								else
									handle:report({ title = d.title, percentage = d.pct })
									-- optional: rerun only this linter
									-- lint.try_lint(d.linter)
								end
							end)
						end

						-- now drive them 500ms apart
						safe_timer_run(fns, 500)
					end),
					50
				)
			end

			-- debounce helper with nil-guards around timer methods
			local function debounce(ms, fn)
				local timer
				return function(...)
					local args = { ... }

					-- cancel and close any existing timer
					if timer then
						timer:stop()
						timer:close()
					end

					-- create a new timer
					timer = vim.loop.new_timer()
					if not timer then
						return
					end

					-- start the timer
					timer:start(ms, 0, function()
						-- schedule the actual lint run on Vim’s main loop
						vim.schedule(function()
							fn(unpack(args))
						end)

						-- safely stop and close the timer
						if timer then
							timer:stop()
							timer:close()
						end
						timer = nil
					end)
				end
			end

			-- create/clear augroup
			local group = vim.api.nvim_create_augroup("nvim-lint", { clear = true })
			-- wire up the autocmd with your debounced runner
			vim.api.nvim_create_autocmd(opts.events, {
				group = group,
				callback = debounce(100, run_lint),
			})

			local function fix()
				local file = vim.api.nvim_buf_get_name(0)
				local cmd = {
					"stylelint",
					"--formatter",
					"json",
					"--config",
					vim.fn.expand("$HOME/.config/stylelint.config.js"),
					"--fix",
					file,
				}

				vim.fn.jobstart(cmd, {
					cwd = vim.fn.getcwd(),
					stdout_buffered = true,
					stderr_buffered = true,
					on_exit = function(_, code)
						if code <= 2 then
							vim.notify("stylelint --fix applied (exit code " .. code .. ")", vim.log.levels.INFO)
							vim.cmd("edit!") -- always reload so you see any changes
						else
							vim.notify("stylelint --fix failed (exit code " .. code .. ")", vim.log.levels.ERROR)
						end
					end,
				})
			end

			wk.add({ "<leader>ll", group = "Lint", icon = "󰝔" })
			wk.add({
				{ "<leader>lls", run_lint, icon = "󰝔", desc = "Linter scan" },
			})
			wk.add({
				{ "<leader>llf", fix, icon = "󰝔", desc = "Linter fix" },
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
				keymap = {
					-- set to 'none' to disable the 'default' preset
					preset = "default",
					["<Up>"] = {},
					["<Down>"] = {},
					["<Left>"] = {},
					["<Right>"] = {},
					["<C-p>"] = { "select_prev", "fallback" },
					["<C-n>"] = { "select_next", "fallback" },
				},
				-- keymap = { preset = "enter" },
				appearance = {
					-- Sets the fallback highlight groups to nvim-cmp's highlight groups
					-- Useful for when your theme doesn't support blink.cmp
					-- will be removed in a future release
					use_nvim_cmp_as_default = true,
					-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = "mono",
				},
				completion = { ghost_text = {
					enabled = true,
				} },
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

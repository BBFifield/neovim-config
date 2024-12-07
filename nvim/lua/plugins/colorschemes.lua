return {
	{
		{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
		"Mofiqul/dracula.nvim",
		"folke/tokyonight.nvim",
		"projekt0n/github-nvim-theme",
		"rebelot/kanagawa.nvim",
		"eldritch-theme/eldritch.nvim",
		"slugbyte/lackluster.nvim",
		"Mofiqul/vscode.nvim",
		"craftzdog/solarized-osaka.nvim",
		"sainnhe/gruvbox-material",
	},
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			local settings_path = vim.fn.expand("~/.config/tintednix/settings.txt")
			local config = {}
			local file = io.open(settings_path, "r")
			if file then
				for line in file:lines() do
					for key, value in string.gmatch(line, "([%a_]+)=([%w%p]+)") do
						config[key] = value
					end
				end
				file:close()
			else
				vim.g.colorscheme = "base16-catppuccin-frappe"
			end
			if config.current_colorscheme then
				vim.g.colorscheme = "base16-" .. config.current_colorscheme
			else
				vim.g.colorscheme = "base16-catppuccin-frappe"
			end

			vim.cmd.colorscheme(vim.g.colorscheme)
			-- Define a function to reload the custom_base16 module
			local function reload_custom_base16()
				package.loaded["plugins.lualine.custom_base16"] = nil
				return require("plugins.lualine.custom_base16")
			end

			local fwatch = require("fwatch")
			local watcher = nil -- Variable to hold the watcher

			local function watch_settings()
				if watcher then
					fwatch.unwatch(watcher) -- Unwatch the existing watcher before re-attaching
				end

				watcher = fwatch.watch(settings_path, {
					on_event = function()
						-- Clear the config table to ensure no old values are retained

						local file = io.open(settings_path, "r")
						if file then
							for line in file:lines() do
								for key, value in string.gmatch(line, "([%a_]+)=([%w%p]+)") do
									config[key] = value
								end
							end
							file:close()
						else
							print("Error: Unable to open settings file")
						end

						if config.current_colorscheme then
							vim.schedule(function()
								vim.cmd.colorscheme("base16-" .. config.current_colorscheme)
								-- Reload colors and update lualine
								local colors = require("base16-colorscheme").colors

								-- Reload the custom_base16 module
								local custom_base16 = reload_custom_base16()

								require("lualine").setup({
									options = {
										icons_enabled = true,
										theme = custom_base16,
										component_separators = { left = "", right = "" },
										section_separators = { left = "", right = "" },
									},
									sections = {
										lualine_a = { { "mode", separator = { left = "", right = "" } } },
										lualine_b = {
											{
												"branch",
												color = { fg = colors.base0E },
											},
											"diff",
											"diagnostics",
										},
										lualine_c = {},
										lualine_x = {},
										lualine_y = { "filetype", "encoding", "fileformat", "progress" },
										lualine_z = { { "location", separator = { left = "", right = "" } } },
									},
									inactive_sections = {
										lualine_a = {},
										lualine_b = {},
										lualine_c = {},
										lualine_x = {},
										lualine_y = {
											"filename",
											"filetype",
										},
										lualine_z = {
											{
												"location",
												separator = { left = "", right = "" },
											},
										},
									},
									extensions = { "lazy" },
								})

								require("lualine").refresh()
							end)
						else
							print("Error: 'current_colorscheme' not set in settings.txt")
						end

						-- Re-attach the watcher
						watch_settings()
					end,
				})
			end

			-- Initially attach the watcher
			watch_settings()
		end,
	},

	{
		"rachartier/tiny-devicons-auto-colors.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		event = "VeryLazy",
		opts = {
			autoreload = true,
		},
	},
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufEnter",
		opts = {},
	},
}

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
		config = function()
			local fwatch = require("fwatch")
			local settings_path = vim.fn.expand("~/.config/tintednix/settings.txt")
			local watcher = nil -- Variable to hold the watcher

			local function watch_settings()
				if watcher then
					fwatch.unwatch(watcher) -- Unwatch the existing watcher before re-attaching
				end

				watcher = fwatch.watch(settings_path, {
					on_event = function()
						-- Clear the config table to ensure no old values are retained
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
							print("Error: Unable to open settings file")
						end

						if config.current_colorscheme then
							vim.schedule(function()
								vim.cmd.colorscheme("base16-" .. config.current_colorscheme)
								-- Reload colors and update lualine
								local colors = require("base16-colorscheme").colors

								local custom_base16 = {
									normal = {
										a = { fg = colors.base01, bg = colors.base0D, gui = "bold" },
										b = { fg = colors.base0D, bg = colors.base01 },
										c = { fg = colors.base03, bg = colors.base02 },
									},
									insert = { a = { fg = colors.base01, bg = colors.base0B, gui = "bold" } },
									visual = { a = { fg = colors.base01, bg = colors.base0E, gui = "bold" } },
									replace = { a = { fg = colors.base01, bg = colors.base08, gui = "bold" } },
									inactive = {
										a = { fg = colors.base0D, bg = colors.base01, gui = "bold" },
										b = { fg = colors.base0D, bg = colors.base01 },
										c = { fg = colors.base0D, bg = colors.base01 },
									},
								}

								require("lualine").setup({
									options = {
										icons_enabled = true,
										theme = custom_base16,
										component_separators = { left = "", right = "" },
										section_separators = { left = "", right = "" },
									},
									sections = {
										lualine_a = { { "mode", separator = { left = "", right = "" } } },
										lualine_b = { { "branch", color = { fg = colors.base0E } } },
										lualine_c = {},
										lualine_x = {},
										lualine_y = { "filetype", "encoding", "fileformat", "progress" },
										lualine_z = { { "location", separator = { left = "", right = "" } } },
									},
									inactive_sections = {
										lualine_a = {},
										lualine_b = {},
										lualine_c = {},
										lualine_x = { "location" },
										lualine_y = {},
										lualine_z = {},
									},
									extensions = {},
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
			factors = {
				lightness = 1.75, -- Adjust the lightness factor.
				chroma = 1, -- Adjust the chroma factor.
				hue = 1.25, -- Adjust the hue factor.
			},
			precise_search = {
				enabled = true,
				iteration = 10, -- It goes hand in hand with 'precision'
				precision = 20, -- The higher the precision, better the search is
				threshold = 23, -- Threshold to consider a color as a match (larger is more permissive)
			},
		},
	},
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufEnter",
		opts = {},
	},
}

return {
	{
		"catppuccin/nvim",
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
				package.loaded["plugins.lualine.custom_themes.base16"] = nil
				return require("plugins.lualine.custom_themes.base16")
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
								local theme
								if NewfieVim:get_plugin_info("base16_nvim").enabled then
									colors = require("base16-colorscheme").colors
									theme = reload_custom_base16()
								else
									theme = "auto"
								end
								-- local tabline = {}
								-- if NewfieVim:get_plugin_info("dropbar").enabled then
								-- 	tabline = vim.tbl_deep_extend("keep", tabline, {
								-- 		tabline = {
								-- 			lualine_b = {
								-- 				{ "dropbar.get_dropbar_str()", separator = { left = "", right = "" } },
								-- 			},
								-- 		},
								-- 	})
								-- elseif NewfieVim:get_plugin_info("navic").enabled then
								-- 	tabline = vim.tbl_deep_extend("keep", tabline, {
								-- 		tabline = {
								-- 			lualine_b = {
								-- 				{
								-- 					"navic",
								-- 					color_correction = "dynamic",
								-- 					separator = { left = "", right = "" },
								-- 					padding = 0,
								-- 					color = { fg = colors.base0D, bg = colors.base01 },
								-- 				},
								-- 			},
								-- 		},
								-- 	})
								-- end

								-- local winbar = {
								-- 	winbar = {
								-- 		lualine_a = {
								-- 			{
								-- 				function()
								-- 					return "%="
								-- 				end,
								-- 				color = { bg = colors.base01, fg = colors.base01 },
								-- 				separator = { right = "%#lualine_b_normal#" },
								-- 			},
								-- 			{
								-- 				"filename",
								-- 				color = { bg = colors.base0D, gui = "bold" },
								-- 				symbols = { modified = "%#file_modified#●" },
								-- 				path = 1,
								-- 				separator = { left = "", right = "" },
								-- 				padding = 0,
								-- 				--fmt = trunc(80, 10, nil, false),
								-- 			},
								-- 			{
								-- 				function()
								-- 					return "%="
								-- 				end,
								-- 				color = { bg = colors.base01 },
								-- 			},
								-- 		},
								-- 	},
								-- }
								-- Reload the custom_base16 module
								local build_lualine_config = require("plugins.lualine.config")

								require("lualine").setup(build_lualine_config(colors, theme))
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
		"xiyaowong/transparent.nvim",
	},
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufEnter",
		opts = {},
	},
}

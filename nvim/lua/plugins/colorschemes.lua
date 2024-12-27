return {
	{
		"catppuccin/nvim",
	},
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
				callback = function()
					local colors = require("base16-colorscheme").colors
					local floatFg = colors.base0D
					local floatBg = vim.g.transparent and nil or colors.base00
					if NewfieVim:get_plugin_info("yazi").enabled then
						vim.api.nvim_set_hl(0, "YaziFloat", { fg = floatFg, bg = floatBg })
					end
					vim.api.nvim_set_hl(0, "FloatBorder", { fg = floatFg, bg = floatBg })
					vim.api.nvim_set_hl(0, "NormalFloat", { fg = floatFg, bg = floatBg })
				end,
			})
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
			if config.color_scheme then
				vim.g.colorscheme = "base16-" .. config.color_scheme
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
						print("event triggered")
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

						if config.color_scheme then
							vim.schedule(function()
								vim.cmd.colorscheme("base16-" .. config.color_scheme)
								-- Reload colors and update lualine
								local colors = require("base16-colorscheme").colors
								local theme = reload_custom_base16()
								-- Reload the custom_base16 module
								local build_lualine_config = require("plugins.lualine.config")
								require("lualine").setup(build_lualine_config(colors, theme))
								require("lualine").refresh()
							end)
						else
							print("Error: 'color_scheme' not set in settings.txt")
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
		"mikesmithgh/borderline.nvim",
		lazy = true,
		event = "VeryLazy",
		config = function()
			require("borderline").setup({})
			local bordertype = vim.g.transparent and "diff" or "rounded"
			vim.cmd.Borderline(bordertype)
		end,
	},
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufEnter",
		opts = {},
	},
}

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
			local settings_file = vim.fn.expand("~/.config/tintednix/settings.txt")
			local settings_dir = vim.fn.expand("~/.config/tintednix")
			local config = {}

			local readFile = function()
				local file = io.open(settings_file, "r")
				if file then
					for line in file:lines() do
						for key, value in string.gmatch(line, "([%a_]+)=([%w%p]+)") do
							config[key] = value
						end
					end
					file:close()
				end
			end
			readFile()
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

			local function watch_settings()
				fwatch.watch(settings_dir, {
					on_event = function(filename, events, unwatch)
						print("event triggered")
						readFile()

						if config.color_scheme then
							vim.schedule(function()
								vim.cmd.colorscheme("base16-" .. config.color_scheme)
								-- Reload colors and update lualine
								local colors = require("base16-colorscheme").colors
								local theme = reload_custom_base16()
								local build_lualine_config = require("plugins.lualine.config")
								require("lualine").setup(build_lualine_config(colors, theme))
								require("lualine").refresh()
							end)
						else
							print("Error: 'color_scheme' not set in settings.txt")
						end
						watch_settings()
						return unwatch()
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

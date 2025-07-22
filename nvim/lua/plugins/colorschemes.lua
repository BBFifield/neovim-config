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
					-- blink.cmp
					vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { fg = colors.base01, bg = floatFg })
					vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = colors.base03 })
					vim.api.nvim_set_hl(0, "IncSearch", { fg = colors.base01, bg = colors.base09 })
					vim.api.nvim_set_hl(0, "CurSearch", { fg = colors.base01, bg = colors.base09 })
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
				local theme = "base16-" .. config.color_scheme
				if string.find(config.color_scheme, "ros%-pine-moon") then
					theme = "base16-rose-pine-moon"
				elseif string.find(config.color_scheme, "ros%-pine") then
					theme = "base16-rose-pine"
				end
				vim.g.colorscheme = theme
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
								local theme = "base16-" .. config.color_scheme
								if string.find(config.color_scheme, "ros%-pine-moon") then
									theme = "base16-rose-pine-moon"
								elseif string.find(config.color_scheme, "ros%-pine") then
									theme = "base16-rose-pine"
								end
								vim.cmd.colorscheme(theme)
								-- Reload colors and update lualine
								local colors = require("base16-colorscheme").colors
								theme = reload_custom_base16()
								local build_lualine_config = require("plugins.lualine.config")
								require("lualine").setup(build_lualine_config(colors, theme))
								-- require("lualine").refresh() -- This was causing the file_modified highlight update in lualine.lua to not persist if the symbol was shown in the interface
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
	-- {
	-- 	"rachartier/tiny-devicons-auto-colors.nvim",
	-- 	dependencies = {
	-- 		"nvim-tree/nvim-web-devicons",
	-- 	},
	-- 	event = "VeryLazy",
	-- 	opts = {
	-- 		autoreload = true,
	-- 	},
	-- },
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

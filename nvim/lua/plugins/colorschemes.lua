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
					vim.api.nvim_set_hl(0, "FloatBorder", { bg = colors.base01 })
					vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.base01 })
					if vim.g.transparent then
						vim.api.nvim_set_hl(0, "Normal", { bg = nil })
						vim.api.nvim_set_hl(0, "NonText", { bg = nil })
					end
					if NewfieVim:get_plugin_info("yazi").enabled then
						vim.api.nvim_set_hl(0, "YaziFloat", { bg = colors.base01 })
					end
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
								local theme = reload_custom_base16()
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
	-- {
	-- 	"mikesmithgh/borderline.nvim",
	-- 	lazy = true,
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		require("borderline").setup({})
	-- 		vim.cmd.Borderline("shadow")
	-- 	end,
	-- },
	{
		"NvChad/nvim-colorizer.lua",
		event = "BufEnter",
		opts = {},
	},
}

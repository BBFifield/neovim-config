vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local active = vim.api.nvim_get_hl(0, { name = "lualine_a_normal" })
		local inactive = vim.api.nvim_get_hl(0, { name = "lualine_b_normal" })
		vim.api.nvim_set_hl(
			0,
			"active_buffer_title",
			{ ctermfg = 18, ctermbg = 12, fg = active.fg, bg = active.bg, bold = true }
		)
		vim.api.nvim_set_hl(
			0,
			"inactive_buffer_title",
			{ ctermfg = 12, ctermbg = 18, fg = inactive.fg, bg = inactive.bg }
		)
	end,
})
return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {},
	config = function(_, opts)
		vim.cmd.colorscheme(vim.g.colorscheme) -- Ensure the colorscheme is applied early

		-- Define and extend winbar
		local winbar = {}
		if NewfieVim:get_plugin_info("navic").enabled then
			local navic = require("nvim-navic")
			local barbecue = require("barbecue.ui")
			winbar = {
				winbar = {
					lualine_c = {
						{
							function()
								return barbecue.update() or ""
							end,
							cond = function()
								return navic.is_available()
							end,
						},
					},
				},
			}
		end

		local tabline = {}
		if NewfieVim:get_plugin_info("lualine").enable_custom_buffers then
			tabline = {
				tabline = {
					lualine_c = {
						{
							require("plugins.lualine.custom_buffers"),
							show_filename_only = true,
							hide_filename_extension = false,
							show_modified_status = true,
							mode = 0,
							filetype_names = {
								checkhealth = "Check Health",
								TelescopePrompt = "Telescope",
							},
							buffers_color = {
								active = "active_buffer_title",
								inactive = "inactive_buffer_title",
							},
							separator = { left = "", right = "" },
							padding = 0,
							max_length = function()
								return vim.o.columns * 4 / 3
							end,
							symbols = {
								modified = "",
							},
							cond = function()
								return vim.bo.filetype ~= "alpha"
									and vim.bo.filetype ~= "lazy"
									and vim.bo.filetype ~= "TelescopePrompt"
									and vim.bo.filetype ~= "NvimTree"
									and vim.bo.filetype ~= "tfm"
							end,
						},
					},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {
						{
							"datetime",
							separator = { left = "", right = "" },
							style = "%H:%M",
						},
					},
				},
			}
		end

		-- Fetch colors for custom theme
		local theme
		local colors = require("base16-colorscheme").colors
		if vim.g.is_base16 then
			theme = require("plugins.lualine.custom_base16")
		else
			theme = "auto"
		end

		require("lualine").setup(vim.tbl_deep_extend("keep", winbar, tabline, {
			options = {
				icons_enabled = true,
				theme = theme,
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
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			extensions = {},
		}))
	end,
}

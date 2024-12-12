local branch_component
if NewfieVim:get_plugin_info("gitsigns").enabled then
	branch_component = "b:gitsigns_head"
else
	branch_component = "branch"
end

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

local build_lualine_config = function(colors, theme)
	local tabline = {}
	if NewfieVim:get_plugin_info("lualine").enable_buffers then
		tabline = {
			tabline = {
				lualine_c = {
					{
						require("plugins.lualine.custom_components.buffers"),
						show_filename_only = true,
						hide_filename_extension = false,
						show_modified_status = true,
						mode = 0,
						filetype_names = {
							checkhealth = "Check Health",
							TelescopePrompt = "Telescope",
						},
						buffers_color = {
							active = "lualine_a_normal",
							inactive = "lualine_b_normal",
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

				lualine_x = {
					{
						"tabs",
						separator = { left = "", right = "" },
						tabs_color = {
							active = "lualine_a_normal",
							inactive = "lualine_b_normal",
						},
					},
				},
				lualine_y = {},
				lualine_z = {},
			},
		}
	elseif NewfieVim:get_plugin_info("dropbar").enabled then
		tabline = vim.tbl_deep_extend("keep", tabline, {
			tabline = {
				lualine_b = {
					{
						"dropbar.get_dropbar_str()",
						separator = { left = "", right = "" },
						padding = 0,
						color = { fg = colors.base0D, bg = colors.base01 },
					},
				},
			},
		})
	elseif NewfieVim:get_plugin_info("navic").enabled then
		tabline = vim.tbl_deep_extend("keep", tabline, {
			tabline = {
				lualine_b = {
					{
						"navic",
						color_correction = "dynamic",
						separator = { left = "", right = "" },
						padding = 0,
						color = { fg = colors.base0D, bg = colors.base01 },
					},
				},
				lualine_x = {
					{
						"tabs",
						separator = { left = "", right = "" },
						tabs_color = {
							active = "lualine_a_normal",
							inactive = "lualine_b_normal",
						},
					},
				},
			},
		})
	else
		tabline = vim.tbl_deep_extend("keep", tabline, {
			tabline = {
				lualine_x = {
					{
						"tabs",
						separator = { left = "", right = "" },
						tabs_color = {
							active = "lualine_a_normal",
							inactive = "lualine_b_normal",
						},
					},
				},
			},
		})
	-- end
	local winbar = {
		winbar = {
			lualine_b = {
				{
					function()
						return "%="
					end,
					color = { bg = colors.base01, fg = colors.base01 },
					separator = {
						right = "%#spacer_separator#",
					},
				},
				{
					"filename",
					color = { bg = colors.base0D, fg = colors.base01, gui = "bold" },
					symbols = { modified = "%#file_modified#●" },
					path = 1,
					separator = { left = "", right = "" },
					padding = 0,
				},
				{
					function()
						return "%="
					end,
					color = { bg = colors.base01 },
				},
			},
		},
	}
	return vim.tbl_deep_extend("keep", winbar, tabline, {
		options = {
			icons_enabled = true,
			theme = theme,
			always_divide_middle = true,
			globalstatus = true,
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
		},
		sections = {
			lualine_a = { { "mode", separator = { left = "", right = "" } } },
			lualine_b = {
				{
					branch_component,
					icon = "",
					color = { fg = colors.base0E },
				},
				{ "diff", source = diff_source() },
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
			lualine_y = {},
		},
		inactive_winbar = {
			lualine_b = {
				{
					function()
						return "%="
					end,
					color = { bg = colors.base01, fg = colors.base01 },
					separator = {
						right = "%#spacer_separator_inactive_win#",
					},
				},
				{
					"filename",
					color = { bg = colors.base02, fg = colors.base0D },
					symbols = { modified = "%#file_modified_inactive_win#●" },
					path = 1,
					separator = { left = "", right = "%#spacer_separator_inactive_win#" },
					padding = 0,
				},
				{
					function()
						return "%="
					end,
					color = { bg = colors.base01 },
				},
			},
		},
		extensions = { "lazy" },
	})
end

return build_lualine_config

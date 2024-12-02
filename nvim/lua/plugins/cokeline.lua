return {

	"willothy/nvim-cokeline",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for v0.4.0+
		"nvim-tree/nvim-web-devicons", -- If you want devicons
		"stevearc/resession.nvim", -- Optional, for persistent history
	},
	opts = {},
	config = function(_, opts)
		local hlgroups = require("cokeline.hlgroups")
		local active_bg_color = "#931E9E"
		local inactive_bg_color = hlgroups.get_hl_attr("Normal", "bg")
		local bg_color = hlgroups.get_hl_attr("ColorColumn", "bg")
		require("cokeline").setup({
			show_if_buffers_are_at_least = 1,
			mappings = {
				cycle_prev_next = true,
			},
			default_hl = {
				bg = function(buffer)
					if buffer.is_focused then
						return active_bg_color
					end
				end,
			},
			components = {
				{
					text = function(buffer)
						local _text = ""
						if buffer.index > 1 then
							_text = " "
						end
						if buffer.is_focused or buffer.is_first then
							_text = _text .. ""
						end
						return _text
					end,
					fg = function(buffer)
						if buffer.is_focused then
							return active_bg_color
						elseif buffer.is_first then
							return inactive_bg_color
						end
					end,
					bg = function(buffer)
						if buffer.is_focused then
							if buffer.is_first then
								return bg_color
							else
								return inactive_bg_color
							end
						elseif buffer.is_first then
							return bg_color
						end
					end,
				},
				{
					text = function(buffer)
						local status = ""
						if buffer.is_readonly then
							status = "➖"
						elseif buffer.is_modified then
							status = ""
						end
						return status
					end,
				},
				{
					text = function(buffer)
						return " " .. buffer.devicon.icon
					end,
					fg = function(buffer)
						if buffer.is_focused then
							return buffer.devicon.color
						end
					end,
				},
				{
					text = function(buffer)
						return buffer.unique_prefix .. buffer.filename
					end,
					fg = function(buffer)
						if buffer.diagnostics.errors > 0 then
							return "#C95157"
						end
					end,
					style = function(buffer)
						local text_style = "NONE"
						if buffer.is_focused then
							text_style = "bold"
						end
						if buffer.diagnostics.errors > 0 then
							if text_style ~= "NONE" then
								text_style = text_style .. ",underline"
							else
								text_style = "underline"
							end
						end
						return text_style
					end,
				},
				{
					text = function(buffer)
						local errors = buffer.diagnostics.errors
						if errors <= 9 then
							errors = ""
						else
							errors = "🙃"
						end
						return errors .. " "
					end,
					fg = function(buffer)
						if buffer.diagnostics.errors == 0 then
							return "#3DEB63"
						elseif buffer.diagnostics.errors <= 9 then
							return "#DB121B"
						end
					end,
				},
				{
					text = "",
					delete_buffer_on_left_click = true,
				},
				{
					text = function(buffer)
						if buffer.is_focused or buffer.is_last then
							return ""
						else
							return " "
						end
					end,
					fg = function(buffer)
						if buffer.is_focused then
							return active_bg_color
						elseif buffer.is_last then
							return inactive_bg_color
						else
							return bg_color
						end
					end,
					bg = function(buffer)
						if buffer.is_focused then
							if buffer.is_last then
								return bg_color
							else
								return inactive_bg_color
							end
						elseif buffer.is_last then
							return bg_color
						end
					end,
				},
			},
		})
	end,
}

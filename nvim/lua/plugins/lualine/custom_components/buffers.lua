-- Custom buffers extension
local custom_buffers = require("lualine.components.buffers"):extend()
local custom_buffers_buffer = require("lualine.components.buffers.buffer"):extend()

function custom_buffers:init(options)
	custom_buffers.super.init(self, options)
	self.options = vim.tbl_deep_extend("force", self.options, { options })
	self.highlights = {
		active = self:create_hl(self.options.buffers_color.active, "active"),
		inactive = self:create_hl(self.options.buffers_color.inactive, "inactive"),
	}
end

function custom_buffers:new_buffer(bufnr, buf_index)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	buf_index = buf_index or ""
	return custom_buffers_buffer:new({
		bufnr = bufnr,
		buf_index = buf_index,
		options = self.options,
		highlights = self.highlights,
	})
end

function custom_buffers_buffer:init(options)
	custom_buffers_buffer.super.init(self, options)
end

function custom_buffers_buffer:name()
	local name = custom_buffers_buffer.super.name(self)

	local general = vim.api.nvim_get_hl(0, { name = "lualine_a_replace" })
	local active = vim.api.nvim_get_hl(0, { name = self.options.buffers_color.active })
	local inactive = vim.api.nvim_get_hl(0, { name = self.options.buffers_color.inactive })
	vim.api.nvim_set_hl(
		0,
		"active_modified",
		{ fg = general.bg, bg = active.bg, ctermfg = general.ctermbg, ctermbg = active.ctermbg }
	)
	vim.api.nvim_set_hl(
		0,
		"inactive_modified",
		{ fg = inactive.fg, bg = inactive.bg, ctermfg = inactive.ctermfg, ctermbg = inactive.ctermbg }
	)
	vim.api.nvim_set_hl(
		0,
		"separator",
		{ fg = active.bg, bg = inactive.bg, ctermfg = active.ctermbg, ctermbg = inactive.ctermbg }
	)

	if self:is_current() and vim.api.nvim_get_option_value("modified", { buf = self.bufnr }) then
		name = name .. "%#active_modified# ●%*"
	elseif not self:is_current() and vim.api.nvim_get_option_value("modified", { buf = self.bufnr }) then
		name = name .. "%#inactive_modified# ○%*"
	end
	return name
end

function custom_buffers_buffer:separator_before()
	if self.current then
		return string.format("%%#separator# %s%%*", self.options.section_separators.right)
	elseif self.aftercurrent then
		return string.format("%%#separator#%s %%*", self.options.section_separators.left)
	else
		return string.format("%%#separator#%s%%*", self.options.component_separators.right)
	end
end

return custom_buffers

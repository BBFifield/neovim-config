local colors = require("base16-colorscheme").colors
local background = vim.g.transparent and nil or colors.base01
local base16 = {
	normal = {
		a = { fg = colors.base01, bg = colors.base0D, gui = "bold" },
		b = { fg = colors.base0D, bg = colors.base02 },
		c = { fg = colors.base03, bg = background },
		--x = { fg = colors.base00, bg = colors.base0D, gui = "bold" },
	},
	insert = {
		a = { fg = colors.base01, bg = colors.base0B, gui = "bold" },
		b = { fg = colors.base0B, bg = colors.base02 },
		c = { fg = colors.base03, bg = background },
	},
	visual = {
		a = { fg = colors.base01, bg = colors.base0E, gui = "bold" },
		b = { fg = colors.base0E, bg = colors.base02 },
		c = { fg = colors.base03, bg = background },
	},
	replace = {
		a = { fg = colors.base01, bg = colors.base08, gui = "bold" },
		b = { fg = colors.base08, bg = colors.base02 },
		c = { fg = colors.base03, bg = background },
	},
	command = {
		a = { fg = colors.base01, bg = colors.base09, gui = "bold" },
		b = { fg = colors.base09, bg = colors.base02 },
		c = { fg = colors.base03, bg = background },
	},
	inactive = {
		a = { fg = colors.base0D, bg = colors.base01 },
		b = { fg = colors.base0D, bg = colors.base01 },
		c = { fg = colors.base0D, bg = background },
		x = { fg = colors.base03, bg = colors.base01 },
		y = { fg = colors.base0D, bg = colors.base02 },
		z = { fg = colors.base01, bg = colors.base0D, gui = "bold" },
	},
}

return base16

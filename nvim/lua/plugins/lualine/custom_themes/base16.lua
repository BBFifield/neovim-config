local colors = require("base16-colorscheme").colors
local base16 = {
	normal = {
		a = { fg = colors.base01, bg = colors.base0D, gui = "bold" },
		b = { fg = colors.base0D, bg = colors.base01 },
		c = { fg = colors.base03, bg = colors.base02 },
		--	x = { fg = colors.base01, bg = colors.base0D, gui = "bold" },
	},
	insert = {
		a = { fg = colors.base01, bg = colors.base0B, gui = "bold" },
		b = { fg = colors.base0B, bg = colors.base01 },
		c = { fg = colors.base03, bg = colors.base02 },
	},
	visual = {
		a = { fg = colors.base01, bg = colors.base0E, gui = "bold" },
		b = { fg = colors.base0E, bg = colors.base01 },
		c = { fg = colors.base03, bg = colors.base02 },
	},
	replace = {
		a = { fg = colors.base01, bg = colors.base08, gui = "bold" },
		b = { fg = colors.base08, bg = colors.base01 },
		c = { fg = colors.base03, bg = colors.base02 },
	},
	command = {
		a = { fg = colors.base01, bg = colors.base09, gui = "bold" },
		b = { fg = colors.base09, bg = colors.base01 },
		c = { fg = colors.base03, bg = colors.base02 },
	},
	inactive = {
		a = { fg = colors.base0D, bg = colors.base02 },
		b = { fg = colors.base0D, bg = colors.base02 },
		c = { fg = colors.base0D, bg = colors.base02 },
		x = { fg = colors.base03, bg = colors.base02 },
		y = { fg = colors.base0D, bg = colors.base01 },
		z = { fg = colors.base01, bg = colors.base0D, gui = "bold" },
	},
}

return base16

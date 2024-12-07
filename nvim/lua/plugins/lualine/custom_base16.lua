local colors = require("base16-colorscheme").colors
local custom_base16 = {
	normal = {
		a = { fg = colors.base01, bg = colors.base0D, gui = "bold" },
		b = { fg = colors.base0D, bg = colors.base01 },
		c = { fg = colors.base03, bg = colors.base02 },
	},
	insert = { a = { fg = colors.base01, bg = colors.base0B, gui = "bold" } },
	visual = { a = { fg = colors.base01, bg = colors.base0E, gui = "bold" } },
	replace = { a = { fg = colors.base01, bg = colors.base08, gui = "bold" } },
	inactive = {
		a = { fg = colors.base0D, bg = colors.base02 },
		b = { fg = colors.base0D, bg = colors.base02 },
		c = { fg = colors.base0D, bg = colors.base02 },
		x = { fg = colors.base03, bg = colors.base02 },
		y = { fg = colors.base0D, bg = colors.base01 },
		z = { fg = colors.base01, bg = colors.base0D, gui = "bold" },
	},
}

return custom_base16

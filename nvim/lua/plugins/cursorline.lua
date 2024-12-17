return {
	{
		"sethen/line-number-change-mode.nvim",
		config = function()
			vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
				callback = function()
					local colors = require("base16-colorscheme").colors

					require("line-number-change-mode").setup({
						mode = {
							i = {
								bg = colors.base01,
								fg = colors.base0B,
								bold = true,
							},
							n = {
								bg = colors.base01,
								fg = colors.base0D,
								bold = true,
							},
							R = {
								bg = colors.base01,
								fg = colors.base08,
								bold = true,
							},
							v = {
								bg = colors.base01,
								fg = colors.base0E,
								bold = true,
							},
							V = {
								bg = colors.base01,
								fg = colors.base0E,
								bold = true,
							},
							c = {
								bg = colors.base01,
								fg = colors.base09,
								bold = true,
							},
						},
					})
				end,
			})
		end,
	},
	{ "RRethy/vim-illuminate" },
}

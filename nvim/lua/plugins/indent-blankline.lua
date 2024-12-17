return {
	"lukas-reineke/indent-blankline.nvim",
	priority = 800,
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	opts = {},
	config = function(_, opts)
		local highlight = {
			"RainbowRed",
			"RainbowYellow",
			"RainbowBlue",
			"RainbowOrange",
			"RainbowGreen",
			"RainbowViolet",
			"RainbowCyan",
		}
		local hooks = require("ibl.hooks")
		-- create the highlight groups in the highlight setup hook, so they are reset
		-- every time the colorscheme changes
		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
			local colors = require("base16-colorscheme").colors
			vim.api.nvim_set_hl(0, "RainbowRed", { fg = colors.base08 })
			vim.api.nvim_set_hl(0, "RainbowYellow", { fg = colors.base0A })
			vim.api.nvim_set_hl(0, "RainbowBlue", { fg = colors.base0D })
			vim.api.nvim_set_hl(0, "RainbowOrange", { fg = colors.base09 })
			vim.api.nvim_set_hl(0, "RainbowGreen", { fg = colors.base0B })
			vim.api.nvim_set_hl(0, "RainbowViolet", { fg = colors.base0E })
			vim.api.nvim_set_hl(0, "RainbowCyan", { fg = colors.base0C })
		end)

		vim.g.rainbow_delimiters = { highlight = highlight }
		require("ibl").setup({ scope = { highlight = highlight } })

		hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
	end,
}

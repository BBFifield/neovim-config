-- For the spacer_separtor_inactive_win highlight group, using base02 instead of base01 results in the left spacer's right separator's disappearance for whatever reason.
if NewfieVim:get_plugin_info("base16_nvim").enabled then
	local update_highlights = function(colors)
		vim.api.nvim_set_hl(0, "file_modified", { fg = colors.base09, bg = colors.base0D })
		vim.api.nvim_set_hl(0, "file_modified_inactive_win", { fg = colors.base09, bg = colors.base02 })
		vim.api.nvim_set_hl(0, "spacer_separator", { fg = colors.base0D, bg = colors.base01 })
		vim.api.nvim_set_hl(0, "spacer_separator_inactive_win", { fg = colors.base02, bg = colors.base01 })
		vim.api.nvim_set_hl(0, "lualine_a_normal", { fg = colors.base01, bg = colors.base0D, bold = true })
		vim.api.nvim_set_hl(0, "lualine_b_normal", { fg = colors.base0D, bg = colors.base01 })
	end
	vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
		callback = function()
			update_highlights(require("base16-colorscheme").colors)
		end,
	})
end

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {},
	config = function(_, opts)
		local colors
		local theme
		if NewfieVim:get_plugin_info("base16_nvim").enabled then
			colors = require("base16-colorscheme").colors
			theme = require("plugins.lualine.custom_themes.base16")
		else
			theme = "auto"
		end

		local build_lualine_config = require("plugins.lualine.config")

		require("lualine").setup(build_lualine_config(colors, theme))
	end,
}

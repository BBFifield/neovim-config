vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local colors = require("base16-colorscheme").colors
		vim.api.nvim_set_hl(0, "NavicIconsFile", { default = true, bg = colors.base01, fg = colors.base05 })
		vim.api.nvim_set_hl(0, "NavicIconsModule", { default = true, bg = colors.base01, fg = colors.base0A })
		vim.api.nvim_set_hl(0, "NavicIconsNamespace", { default = true, bg = colors.base01, fg = colors.base0B })
		vim.api.nvim_set_hl(0, "NavicIconsPackage", { default = true, bg = colors.base01, fg = colors.base08 })
		vim.api.nvim_set_hl(0, "NavicIconsClass", { default = true, bg = colors.base01, fg = colors.base0E })
		vim.api.nvim_set_hl(0, "NavicIconsMethod", { default = true, bg = colors.base01, fg = colors.base0C })
		vim.api.nvim_set_hl(0, "NavicIconsProperty", { default = true, bg = colors.base01, fg = colors.base0F })
		vim.api.nvim_set_hl(0, "NavicIconsField", { default = true, bg = colors.base01, fg = colors.base07 })
		vim.api.nvim_set_hl(0, "NavicIconsConstructor", { default = true, bg = colors.base01, fg = colors.base09 })
		vim.api.nvim_set_hl(0, "NavicIconsEnum", { default = true, bg = colors.base01, fg = colors.base0A })
		vim.api.nvim_set_hl(0, "NavicIconsInterface", { default = true, bg = colors.base01, fg = colors.base0B })
		vim.api.nvim_set_hl(0, "NavicIconsFunction", { default = true, bg = colors.base01, fg = colors.base0C })
		vim.api.nvim_set_hl(0, "NavicIconsVariable", { default = true, bg = colors.base01, fg = colors.base08 })
		vim.api.nvim_set_hl(0, "NavicIconsConstant", { default = true, bg = colors.base01, fg = colors.base09 })
		vim.api.nvim_set_hl(0, "NavicIconsString", { default = true, bg = colors.base01, fg = colors.base0D })
		vim.api.nvim_set_hl(0, "NavicIconsNumber", { default = true, bg = colors.base01, fg = colors.base0E })
		vim.api.nvim_set_hl(0, "NavicIconsBoolean", { default = true, bg = colors.base01, fg = colors.base0F })
		vim.api.nvim_set_hl(0, "NavicIconsArray", { default = true, bg = colors.base01, fg = colors.base07 })
		vim.api.nvim_set_hl(0, "NavicIconsObject", { default = true, bg = colors.base01, fg = colors.base05 })
		vim.api.nvim_set_hl(0, "NavicIconsKey", { default = true, bg = colors.base01, fg = colors.base03 })
		vim.api.nvim_set_hl(0, "NavicIconsNull", { default = true, bg = colors.base01, fg = colors.base01 })
		vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { default = true, bg = colors.base01, fg = colors.base0C })
		vim.api.nvim_set_hl(0, "NavicIconsStruct", { default = true, bg = colors.base01, fg = colors.base02 })
		vim.api.nvim_set_hl(0, "NavicIconsEvent", { default = true, bg = colors.base01, fg = colors.base0A })
		vim.api.nvim_set_hl(0, "NavicIconsOperator", { default = true, bg = colors.base01, fg = colors.base0B })
		vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { default = true, bg = colors.base01, fg = colors.base09 })
		vim.api.nvim_set_hl(0, "NavicText", { default = true, bg = colors.base01, fg = colors.base05 })
		vim.api.nvim_set_hl(0, "NavicSeparator", { default = true, bg = colors.base01, fg = colors.base04 })
	end,
})
if NewfieVim:get_plugin_info("base16_nvim").enabled then
	local update_highlights = function(colors)
		vim.api.nvim_set_hl(0, "NavicIconsFile", { default = true, bg = colors.base01, fg = colors.base05 })
		vim.api.nvim_set_hl(0, "NavicIconsModule", { default = true, bg = colors.base01, fg = colors.base0A })
		vim.api.nvim_set_hl(0, "NavicIconsNamespace", { default = true, bg = colors.base01, fg = colors.base0B })
		vim.api.nvim_set_hl(0, "NavicIconsPackage", { default = true, bg = colors.base01, fg = colors.base08 })
		vim.api.nvim_set_hl(0, "NavicIconsClass", { default = true, bg = colors.base01, fg = colors.base0E })
		vim.api.nvim_set_hl(0, "NavicIconsMethod", { default = true, bg = colors.base01, fg = colors.base0C })
		vim.api.nvim_set_hl(0, "NavicIconsProperty", { default = true, bg = colors.base01, fg = colors.base0F })
		vim.api.nvim_set_hl(0, "NavicIconsField", { default = true, bg = colors.base01, fg = colors.base07 })
		vim.api.nvim_set_hl(0, "NavicIconsConstructor", { default = true, bg = colors.base01, fg = colors.base09 })
		vim.api.nvim_set_hl(0, "NavicIconsEnum", { default = true, bg = colors.base01, fg = colors.base0A })
		vim.api.nvim_set_hl(0, "NavicIconsInterface", { default = true, bg = colors.base01, fg = colors.base0B })
		vim.api.nvim_set_hl(0, "NavicIconsFunction", { default = true, bg = colors.base01, fg = colors.base0C })
		vim.api.nvim_set_hl(0, "NavicIconsVariable", { default = true, bg = colors.base01, fg = colors.base08 })
		vim.api.nvim_set_hl(0, "NavicIconsConstant", { default = true, bg = colors.base01, fg = colors.base09 })
		vim.api.nvim_set_hl(0, "NavicIconsString", { default = true, bg = colors.base01, fg = colors.base0D })
		vim.api.nvim_set_hl(0, "NavicIconsNumber", { default = true, bg = colors.base01, fg = colors.base0E })
		vim.api.nvim_set_hl(0, "NavicIconsBoolean", { default = true, bg = colors.base01, fg = colors.base0F })
		vim.api.nvim_set_hl(0, "NavicIconsArray", { default = true, bg = colors.base01, fg = colors.base07 })
		vim.api.nvim_set_hl(0, "NavicIconsObject", { default = true, bg = colors.base01, fg = colors.base05 })
		vim.api.nvim_set_hl(0, "NavicIconsKey", { default = true, bg = colors.base01, fg = colors.base03 })
		vim.api.nvim_set_hl(0, "NavicIconsNull", { default = true, bg = colors.base01, fg = colors.base01 })
		vim.api.nvim_set_hl(0, "NavicIconsEnumMember", { default = true, bg = colors.base01, fg = colors.base0C })
		vim.api.nvim_set_hl(0, "NavicIconsStruct", { default = true, bg = colors.base01, fg = colors.base02 })
		vim.api.nvim_set_hl(0, "NavicIconsEvent", { default = true, bg = colors.base01, fg = colors.base0A })
		vim.api.nvim_set_hl(0, "NavicIconsOperator", { default = true, bg = colors.base01, fg = colors.base0B })
		vim.api.nvim_set_hl(0, "NavicIconsTypeParameter", { default = true, bg = colors.base01, fg = colors.base09 })
		vim.api.nvim_set_hl(0, "NavicText", { default = true, bg = colors.base01, fg = colors.base05 })
		vim.api.nvim_set_hl(0, "NavicSeparator", { default = true, bg = colors.base01, fg = colors.base04 })
	end
	vim.api.nvim_create_autocmd("ColorScheme", {
		callback = function()
			update_highlights(require("base16-colorscheme").colors)
		end,
	})
end

return {
	{
		"SmiteshP/nvim-navic",
		enabled = NewfieVim:get_plugin_info("navic").enabled,
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			local navic = require("nvim-navic")
			navic.setup({
				highlight = true,
				click = true,
				separator = "  ",
				safe_output = true,
				--	lazy_update_context = "true",
			})
		end,
	},

	{
		"utilyre/barbecue.nvim",
		enabled = NewfieVim:get_plugin_info("navic").enabled,
		name = "barbecue",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {
			attach_navic = false, --Makes navic work with multiple tabs or something when set to false, haven't tested it
			create_autocmd = false,
			show_navic = true,
			theme = {
				-- this highlight is used to override other highlights
				-- you can take advantage of its `bg` and set a background throughout your winbar
				-- (e.g. basename will look like this: { fg = "#c0caf5", bold = true })
				normal = { bg = "NONE" },
			},
		},
		--[[	config = function(_, opts)
			-- triggers CursorHold event faster
			vim.opt.updatetime = 200

			require("barbecue").setup(opts)

			vim.api.nvim_create_autocmd({
				"WinResized", -- or WinResized on NVIM-v0.9 and higher
				"BufWinEnter",
				"CursorHold",
				"InsertLeave",

				-- include this if you have set `show_modified` to `true`
				--"BufModifiedSet",
			}, {
				group = vim.api.nvim_create_augroup("barbecue.updater", {}),
				callback = function()
					require("barbecue.ui").update()
				end,
			})
		end,]]
	},
}

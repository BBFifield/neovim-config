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

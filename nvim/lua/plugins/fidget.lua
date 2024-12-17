return {
	"j-hui/fidget.nvim",
	version = "*",
	opts = {
		progress = {
			display = {
				done_icon = "",
				progress_icon = {
					{
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
						"",
					},
					period = 0.5,
				},
				icon_style = "WarningMsg",
			},
		},
		notification = {
			window = {
				x_padding = 2,
				y_padding = 1,
			},
		},
	},
	config = function(_, opts)
		local winblend = vim.g.transparent and 0 or 100
		require("fidget").setup(vim.tbl_deep_extend("keep", {
			notification = {
				window = {
					winblend = winblend,
				},
			},
		}, opts))
	end,
}

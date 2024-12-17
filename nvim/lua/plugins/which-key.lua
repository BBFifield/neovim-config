return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "classic",
		delay = 500,
		spec = {
			{ "<leader>c", group = "Commands", icon = "" },
			{
				"<leader>b",
				group = "Buffers",
				icon = "",
				expand = function()
					return require("which-key.extras").expand.buf()
				end,
			},
			{ "<leader>d", group = "Directories", icon = "" },
			{ "<leader>f", group = "Files" },
			{ "<leader>g", group = "Git" },
			{ "<leader>h", group = "Help", icon = "󰋖" },
			{ "<leader>l", group = "LSP", icon = "󰿘" },
			{ "<leader>u", group = "UI" },
			{ "<leader>w", proxy = "<c-w>", group = "Windows" },
		},
	},
	keys = {},
}

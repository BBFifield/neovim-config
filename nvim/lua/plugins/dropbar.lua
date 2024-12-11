return {
	"Bekaboo/dropbar.nvim",
	enabled = NewfieVim:get_plugin_info("dropbar").enabled,
	-- optional, but required for fuzzy finder support
	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
	},
	opts = {
		menu = {
			-- When on, preview the symbol under the cursor on CursorMoved
			preview = false,
			-- When on, automatically set the cursor to the closest previous/next
			-- clickable component in the direction of cursor movement on CursorMoved
			quick_navigation = false,
			entry = {
				padding = {
					left = 0,
					right = 0,
				},
			},
			win_configs = {
				border = "rounded",
				style = "minimal",
			},
		},
	},
}

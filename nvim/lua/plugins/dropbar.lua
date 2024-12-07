return {
	"Bekaboo/dropbar.nvim",
	enabled = NewfieVim:get_plugin_info("dropbar").enabled,
	-- optional, but required for fuzzy finder support
	dependencies = {
		"nvim-telescope/telescope-fzf-native.nvim",
	},
	opts = {
		-- sources = {
		-- 	lsp = true,
		-- 	path = true,
		-- 	treesitter = true,
		-- 	markdown = true,
		-- 	terminal = true,
		-- },
		-- Add more configuration options as needed
	},
}

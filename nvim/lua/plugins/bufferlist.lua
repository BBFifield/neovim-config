return {
	{
		"EL-MASTOR/bufferlist.nvim",
		lazy = true,
		keys = { { "<Leader>bl", ":BufferList<CR>", desc = "Open bufferlist" } },
		dependencies = "nvim-tree/nvim-web-devicons",
		cmd = "BufferList",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},
	-- {
	-- 	"matbme/JABS.nvim",
	-- 	lazy = true,
	-- 	keys = { { "<Leader>bl", ":JABSOpen<CR>", desc = "Open bufferlist", silent = true } },
	-- 	opts = { -- Options for the main window
	-- 		position = { "center", "top" }, -- position = {'<position_x>', '<position_y>'} | <position_x> left, center, right, <position_y> top, center, bottom
	--
	-- 		relative = "win", -- win, editor, cursor. Default win
	-- 		clip_popup_size = true, -- clips the popup size to the win (or editor) size. Default true
	--
	-- 		width = 50, -- default 50
	-- 		height = 10, -- default 10
	-- 		border = "shadow", -- none, single, double, rounded, solid, shadow, (or an array or chars). Default shadow
	--
	-- 		offset = { -- window position offset
	-- 			top = 2, -- default 0
	-- 		},
	--
	-- 		sort_mru = true, -- Sort buffers by most recently used (true or false). Default false
	-- 		split_filename = true, -- Split filename into separate components for name and path. Default false
	-- 		split_filename_path_width = 20, -- If split_filename is true, how wide the column for the path is supposed to be, Default 0 (don't show path)
	--
	-- 		-- Options for preview window
	-- 		preview_position = "bottom", -- top, bottom, left, right. Default top
	-- 		preview = {
	-- 			width = 70, -- default 70
	-- 			height = 30, -- default 30
	-- 			border = "shadow", -- none, single, double, rounded, solid, shadow, (or an array or chars). Default double
	-- 		},
	--
	-- 		-- Default highlights (must be a valid :highlight)
	-- 		highlight = {
	-- 			current = "Title", -- default StatusLine
	-- 			hidden = "StatusLineNC", -- default ModeMsg
	-- 			split = "WarningMsg", -- default StatusLine
	-- 			alternate = "StatusLine", -- default WarningMsg
	-- 		},
	--
	-- 		symbols = {
	-- 			current = "",
	-- 			hidden = "󰘓",
	-- 			alternate = "󰐣", -- default 
	-- 			locked = "󰌾", -- default 
	-- 			ro = "󰈈", -- default 
	-- 			edited = "", -- default 
	-- 		},
	-- 		-- Keymaps
	-- 		keymap = {
	-- 			h_split = "h", -- Horizontally split buffer. Default s
	-- 			v_split = "v", -- Vertically split buffer. Default v
	-- 			preview = "p", -- Open buffer preview. Default P
	-- 		},
	-- 	},
	-- },
}

-- Define a function to set Notify highlight groups
local function set_notify_highlights()
	local colors = require("base16-colorscheme").colors
	vim.api.nvim_set_hl(0, "NotifyBackground", { bg = colors.base01 })
	vim.api.nvim_set_hl(0, "NotifyERRORBorder", { fg = colors.base08 })
	vim.api.nvim_set_hl(0, "NotifyWARNBorder", { fg = colors.base09 })
	vim.api.nvim_set_hl(0, "NotifyINFOBorder", { fg = colors.base0B })
	vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { fg = colors.base03 })
	vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { fg = colors.base02 })
	vim.api.nvim_set_hl(0, "NotifyERRORIcon", { fg = colors.base08 })
	vim.api.nvim_set_hl(0, "NotifyWARNIcon", { fg = colors.base09 })
	vim.api.nvim_set_hl(0, "NotifyINFOIcon", { fg = colors.base0B })
	vim.api.nvim_set_hl(0, "NotifyDEBUGIcon", { fg = colors.base03 })
	vim.api.nvim_set_hl(0, "NotifyTRACEIcon", { fg = colors.base0E })
	vim.api.nvim_set_hl(0, "NotifyERRORTitle", { fg = colors.base08 })
	vim.api.nvim_set_hl(0, "NotifyWARNTitle", { fg = colors.base09 })
	vim.api.nvim_set_hl(0, "NotifyINFOTitle", { fg = colors.base0B })
	vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { fg = colors.base03 })
	vim.api.nvim_set_hl(0, "NotifyTRACETitle", { fg = colors.base0E })
	vim.api.nvim_set_hl(0, "NotifyERRORBody", { fg = colors.base08 })
	vim.api.nvim_set_hl(0, "NotifyWARNBody", { fg = colors.base0A })
	vim.api.nvim_set_hl(0, "NotifyINFOBody", { fg = colors.base0D })
	vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { fg = colors.base03 })
	vim.api.nvim_set_hl(0, "NotifyTRACEBody", { fg = colors.base02 })
end

-- Plugin setup
return {
	"rcarriga/nvim-notify",
	config = function()
		-- Set up autocommands to call the function
		vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
			callback = set_notify_highlights,
		})
		require("notify").setup({
			background_colour = "NotifyBackground",
			fps = 60,
		})

		vim.notify = require("notify")
	end,
}

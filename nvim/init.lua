vim.g.mapleader = " "
vim.g.is_base16 = true
if vim.g.is_base16 then
	local settings_path = vim.fn.expand("~/.config/tintednix/settings.txt")
	local config = {}
	local file = io.open(settings_path, "r")
	if file then
		for line in file:lines() do
			for key, value in string.gmatch(line, "([%a_]+)=([%w%p]+)") do
				config[key] = value
			end
		end
		file:close()
	else
		vim.g.colorscheme = "base16-catppuccin-frappe"
	end
	if config.current_colorscheme then
		vim.g.colorscheme = "base16-" .. config.current_colorscheme
	else
		vim.g.colorscheme = "base16-catppuccin-frappe"
	end
else
	vim.g.colorscheme = "catppuccin-mocha"
end

vim.g.mapleader = " "
vim.opt.mousemoveevent = true
vim.opt.termguicolors = true

vim.opt.tabstop = 2 -- Number of spaces that a <Tab> in the file counts for
vim.opt.shiftwidth = 2 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.autoindent = true -- Copy indent from current line when starting a new line

-- Need to load plugins installed by nix before Lazy

require("lib.misc")
require("config.lazy")
NewfieVim_object = require("config.newfievim")

local opts = {
	plugin_list = {
		base16_nvim = { "RRethy/base16-nvim", enabled = vim.g.is_base16 },
		alpha = { "goolord/alpha-nvim", enabled = true },
		dropbar = { "Bekaboo/dropbar.nvim", enabled = false },
		fidget = { "j-hui/fidget.nvim", enabled = true },
		indent_blankline = { "lukas-reineke/indent-blankline.nvim", enabled = true },
		lsp_config = { "neovim/nvim-lspconfig", enabled = true },
		lualine = { "nvim-lualine/lualine.nvim", enabled = true },
		navic = { "SmiteshP/nvim-navic", enabled = true },
		nvim_tree = { "nvim-tree/nvim-tree.lua", enabled = false },
		nvim_treesitter = { "nvim-treesitter/nvim-treesitter", enabled = true },
		telescope = { "nvim-telescope/telescope.nvim", enabled = true },
		tfm = { "rolv-apneseth/tfm.nvim", enabled = true },
		which_key = { "folke/which-key.nvim", enabled = true },
		cokeline = { "willothy/nvim-cokeline", enabled = true },
	},
}
NewfieVim = NewfieVim_object:new(opts) -- Create a new NewfieVim object
NewfieVim:initialize_plugins()

require("config.keymaps")

vim.cmd.colorscheme(vim.g.colorscheme)
vim.wo.number = true
vim.wo.cursorline = true

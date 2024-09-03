vim.g.mapleader = ' '
vim.g.colorscheme = "catppuccin"

require("config.lazy")
require("config.keymaps")

vim.cmd.colorscheme(vim.g.colorscheme)
vim.wo.number = true
vim.wo.cursorline = true


local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, key_opts("Find files"))
vim.keymap.set('n', '<leader>fg', builtin.live_grep, key_opts("Live grep"))
vim.keymap.set('n', '<leader>fb', builtin.buffers, key_opts("Buffers"))
vim.keymap.set('n', '<leader>fh', builtin.help_tags, key_opts("Help tags"))
vim.keymap.set('n', '<leader>fc', builtin.colorscheme, key_opts("Color schemes"))

local actions = require('telescope.actions')
local telescope = require('telescope')

return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "BurntSushi/ripgrep",
        "nvim-telescope/telescope-fzy-native.nvim",
        "sharkdp/fd"
    },
    event = "VimEnter",
    opts = {
        defaults = {
            mappings = {
                i = {
                    ["<esc>"] = actions.close,
                    ["<C-h>"] = actions.which_key,
                },
            },
        },
        pickers = {
            find_files = {
                theme = "dropdown",
            },
            colorscheme = {
                enable_preview = true,
            },
        },
    },
    config = function(_, opts)
        telescope.setup(opts)
        telescope.load_extension('fzy_native')
    end
}
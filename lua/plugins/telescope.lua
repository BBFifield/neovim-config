local opts = function(desc)
    return { desc = desc, silent = true }
end

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, opts("Find files"))
vim.keymap.set('n', '<leader>fg', builtin.live_grep, opts("Live grep"))
vim.keymap.set('n', '<leader>fb', builtin.buffers, opts("Buffers"))
vim.keymap.set('n', '<leader>fh', builtin.help_tags, opts("Help Tags"))

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
    opt = function()
        defaults = {
            mappings = {
                i = {
                    ["<esc>"] = actions.close,
                    ["<C-h>"] = actions.which_key
                },
            },
        }
    end,
    config = function()
        telescope.setup()
        telescope.load_extension('fzy_native')
    end
}
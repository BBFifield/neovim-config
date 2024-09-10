return {
    'SmiteshP/nvim-navic',
    dependencies = { 'neovim/nvim-lspconfig' },
    config = function()
        local navic = require'nvim-navic'
        navic.setup({
            highlight = true,
            click = true,
            separator = '  ',
        })
    end
}


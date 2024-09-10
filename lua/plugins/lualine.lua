return {
    'nvim-lualine/lualine.nvim', 
    dependencies = { 
        'nvim-tree/nvim-web-devicons', 
    },
    opts = {},
    config = function(_, opts)
        local navic = require'nvim-navic'
        require'lualine'.setup({
            winbar = {
                lualine_c = {
                    {
                    function()
                        return navic.get_location() or "N/A"
                    end,
                    cond = function()
                        return navic.is_available()
                    end
                    },
                }
            }
        })
    end
}
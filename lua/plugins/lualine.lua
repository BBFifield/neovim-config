--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.o.columns
    if hide_width and win_width < hide_width then
      return ''
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
    end
    return str
  end
end

return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {},
  config = function(_, opts)
    local custom_buffers = require('lualine.components.buffers'):extend()
    local custom_buffers_buffer = require('lualine.components.buffers.buffer'):extend()

    function custom_buffers:init(options)
      custom_buffers.super.init(self, options)
      --self.super.bufnr = vim.api.nvim_get_current_buf()
      self.options = vim.tbl_deep_extend('force', self.options, { options })
      self.highlights = {
        active = self:create_hl(self.options.buffers_color.active, 'active'),
        inactive = self:create_hl(self.options.buffers_color.inactive, 'inactive'),
      }
    end

    function custom_buffers:new_buffer(bufnr, buf_index)
      bufnr = bufnr or vim.api.nvim_get_current_buf()
      buf_index = buf_index or ''
      return custom_buffers_buffer:new {
        bufnr = bufnr,
        buf_index = buf_index,
        options = self.options,
        highlights = self.highlights,
      }
    end

    function custom_buffers_buffer:init(opts)
      custom_buffers_buffer.super.init(self, opts)
    end

    function custom_buffers_buffer:name()
      local name
      local general_fg = vim.api.nvim_get_hl(0, { name = 'lualine_a_replace' }).bg
      local active_bg = vim.api.nvim_get_hl(0, { name = self.options.buffers_color.active }).bg
      local inactive_bg = vim.api.nvim_get_hl(0, { name = self.options.buffers_color.inactive }).bg
      vim.api.nvim_set_hl(0, 'active_modified', { fg = general_fg, bg = active_bg })
      vim.api.nvim_set_hl(0, 'inactive_modified', { fg = general_fg, bg = inactive_bg })

      if self.options.show_filename_only then
        name = vim.fn.fnamemodify(self.file, ':t')
      else
        name = custom_buffers_buffer.super.name(self)
      end

      if self:is_current() and vim.api.nvim_get_option_value('modified', { buf = self.bufnr }) then
        name = name .. '%#active_modified# ● %*'
      elseif not self:is_current() and vim.api.nvim_get_option_value('modified', { buf = self.bufnr }) then
        name = name .. '%#inactive_modified# ○ %*'
      end
      return name
    end

    function custom_buffers_buffer:separator_before()
      if self.current or self.aftercurrent then
        return '%Z{' .. self.options.section_separators.left .. '}'
      else
        return string.format('%%#lualine_b_normal#%s%%*', self.options.component_separators.left)
      end
    end

    local navic = require 'nvim-navic'
    require 'lualine'.setup({
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
      },
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
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch' },
        lualine_c = {},
        lualine_x = { 'filetype', 'encoding', 'fileformat' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {
        lualine_c = {
          {
            custom_buffers,
            show_filename_only = true,
            hide_filename_extension = false,
            show_modified_status = true,
            mode = 0,
            --max_length = vim.o.columns * 2,
            filetype_names = {},
            buffers_color = {
              active = 'lualine_a_normal',
              inactive = 'lualine_b_normal',
            },
            separator = { left = '', right = '' },
            padding = { left = 0, right = 0 },
            max_length = function()
              return vim.o.columns * 4 / 3
            end,
            --fmt = trunc(300, 200, 50, false),
            symbols = {
              modified = '',
            },

            cond = function()
              return vim.bo.filetype ~= 'alpha'
                  and vim.bo.filetype ~= 'lazy'
                  and vim.bo.filetype ~= 'TelescopePrompt'
                  and vim.bo.filetype ~= 'NvimTree'
            end,
          },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {
          {
            'datetime',
            --options: default, us, uk, iso, or your own format string ("%H:%M", etc..)
            style = '%H:%M'
          }
        }
      },
      extensions = {}
    })
  end
}

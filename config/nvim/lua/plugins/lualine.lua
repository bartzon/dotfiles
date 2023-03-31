local Plugin = {'nvim-lualine/lualine.nvim'}

function Plugin.config()
  require('lualine').setup({
    options = {
      theme = 'gruvbox-material',
      always_divide_middle = true
    },
    sections = {
      lualine_a = {
        'branch'
      },
      lualine_b = {
        {
          'filename',
          file_status = true,
          path = 1,
        }
      },
      lualine_c = {
        { },
      },
      lualine_x = {'fileformat', 'filetype'},
      lualine_y = {'progress'},
      lualine_z = {'diagnostics'}
    }
  })
end

return Plugin

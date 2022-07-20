Plug 'nvim-lualine/lualine.nvim'

lua<<EOF
function lualine_setup()
  local gps = require("nvim-gps")

  require('lualine').setup({
    options = {
      theme = 'gruvbox-material',
      always_divide_middle = true,
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
        { gps.get_location },
      },
    lualine_x = {'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'diagnostics'}
    },
  })
end
EOF

augroup LualineSetup
  autocmd User PlugLoaded ++nested lua lualine_setup()
augroup end

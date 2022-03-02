Plug 'nvim-lualine/lualine.nvim'

lua<<EOF
function lualine_setup()
  require('lualine').setup({
  options = {
    theme = 'gruvbox-material',
    always_divide_middle = true,
    },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {
      {
          'filename',
          file_status = true,
          path = 1,
          shorting_target = 40,
    }
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

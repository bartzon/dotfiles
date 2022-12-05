Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'stevearc/dressing.nvim'

lua<<EOF
function setup_dressing()
  require('dressing').setup({})
end
EOF

augroup TelescopeSetup
  autocmd User PlugLoaded ++nested lua setup_dressing()
augroup end

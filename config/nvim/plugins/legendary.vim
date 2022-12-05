Plug 'mrjones2014/legendary.nvim'

lua<<EOF
function setup_legendary()
  require('legendary').setup({})
end
EOF

augroup LegendarySetup
  autocmd User PlugLoaded ++nested lua setup_legendary()
augroup end

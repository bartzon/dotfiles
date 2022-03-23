Plug 'SmiteshP/nvim-gps'

lua<<EOF
function setup_nvim_gps()
  require("nvim-gps").setup()
end
EOF

augroup GPSSetup
  autocmd User PlugLoaded ++nested lua setup_nvim_gps()
augroup end

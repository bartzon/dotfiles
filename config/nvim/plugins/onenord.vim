Plug 'rmehri01/onenord.nvim', { 'branch': 'main' }

lua<<EOF
function onenord_setup()
  require('onenord').setup({
    theme = "dark",
    borders = true, -- Split window borders
    fade_nc = true, -- Fade non-current windows, making them more distinguishable
  })
end
EOF

augroup OneNordOverride
  autocmd User PlugLoaded ++nested lua onenord_setup()
augroup end

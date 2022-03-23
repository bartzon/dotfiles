Plug 'lukas-reineke/indent-blankline.nvim'

lua<<EOF
function indent_setup()
  require("indent_blankline").setup {
    space_char_blankline = " ",
    show_current_context = true,
    show_current_context_start = true,
}
end
EOF

augroup IndentOverride
  autocmd User PlugLoaded ++nested lua indent_setup()
augroup end

Plug 'gruvbox-community/gruvbox'

augroup GruvboxOverride
  autocmd User PlugLoaded ++nested colorscheme gruvbox
augroup end

set bg=dark
let g:gruvbox_italic = 1
let g:gruvbox_italicize_strings = 1
let g:gruvbox_improved_warnings = 1
let g:gruvbox_italicize_comments = 1
let g:gruvbox_underline = 0


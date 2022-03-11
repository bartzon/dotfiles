Plug 'gruvbox-community/gruvbox'

set bg=dark
let g:gruvbox_italic = '1'
let g:gruvbox_italicize_strings = '1'
let g:gruvbox_improved_warnings = '1'
let g:gruvbox_italicize_comments = '1'
let g:gruvbox_underline = '0'

augroup GruvboxOverride
  autocmd User PlugLoaded ++nested colorscheme gruvbox
augroup end

augroup FormatSorbetAsComments
  autocmd Syntax ruby syn region sorbetSig start='sig {' end='}'
  autocmd Syntax ruby syn region sorbetSigDo start='sig do' end='end'
  autocmd Syntax ruby hi def link sorbetSig Comment
  autocmd Syntax ruby hi def link sorbetSigDo Comment
augroup end

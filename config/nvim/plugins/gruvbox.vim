Plug 'morhetz/gruvbox'

set bg=dark
let g:gruvbox_material_palette = 'original'
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_visual = 'blue background'
let g:gruvbox_material_diagnostic_virtual_text = 'colored'
let g:gruvbox_material_statusline_style = 'original'
let g:gruvbox_material_better_performance = 1

augroup GruvboxOverride
  autocmd User PlugLoaded ++nested colorscheme gruvbox
augroup end

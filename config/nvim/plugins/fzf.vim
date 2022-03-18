Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'

" https://github.com/junegunn/dotfiles/commit/9545174d0e34075d16c1d6a01eed820bce9d6cc0
if has('nvim') && exists('&winblend') && &termguicolors
  set winblend=10

  hi NormalFloat guibg=None
  if exists('g:fzf_colors.bg')
    call remove(g:fzf_colors, 'bg')
  endif

  if stridx($FZF_DEFAULT_OPTS, '--border') == -1
    let $FZF_DEFAULT_OPTS .= ' --border'
  endif

  function! FloatingFZF()
    let width = float2nr(&columns * 0.8)
    let height = float2nr(&lines * 0.6)
    let opts = { 'relative': 'editor',
               \ 'style': 'minimal',
               \ 'border': 'shadow',
               \ 'row': (&lines - height) / 2,
               \ 'col': (&columns - width) / 2,
               \ 'width': width,
               \ 'height': height }

    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
  endfunction

  let g:fzf_layout = { 'window': 'call FloatingFZF()' }
endif

let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'

function s:files()
  if empty(FugitiveGitDir())
    :Files
  else
    :GFiles
  endif
endfunction

nmap <leader>b :Buffers<cr>
nmap <leader>r :Rg<cr>
nmap <leader>R :Rg<space>
nmap <leader>gb :GBranches<cr>

nnoremap <C-p> :call <SID>files()<CR>

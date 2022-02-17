Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'

if exists('$TMUX')
    let g:fzf_layout = { 'tmux': '-p90%,60%' }
else
    let g:fzf_layout = { 'down':'20' }
end

let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'

nmap <leader>f :Files<cr>
nmap <leader>F :AllFiles<cr>
nmap <leader>b :Buffers<cr>
nmap <leader>r :Rg<cr>
nmap <leader>R :Rg<space>
nmap <leader>gb :GBranches<cr>

nnoremap <C-p> :Files<CR>

" ---------------------------------------------------
" Settings
" ---------------------------------------------------
set hidden
set expandtab
set path+=** " search down in subfolders
set shiftwidth=2
set tabstop=2
set relativenumber
set number
set termguicolors
set undofile
set notitle
set ignorecase
set smartcase
set wildmode=longest:full,full
set nowrap
set list
set listchars=tab:␉·,trail:␠,nbsp:⎵
set mouse=a
set scrolloff=8
set sidescrolloff=8
set nojoinspaces
set splitbelow
set splitright
set clipboard=unnamedplus
set confirm
set exrc
set backup
set updatetime=300
set redrawtime=10000
set nobackup
set noswapfile
set autoread
set equalalways
set nohlsearch

set statusline=%f " show full filename

let g:netrw_banner=0
let g:netrw_liststyle=3

syntax enable

call matchadd('ColorColumn', '\%121v')

" ---------------------------------------------------
" Keymappings
" ---------------------------------------------------
nmap <leader>ve :edit ~/.config/nvim/init.vim<cr>
nmap <leader>vr :source ~/.config/nvim/init.vim<cr>

command! -bang -nargs=* RgExact
  \ call fzf#vim#grep(
  \   'rg -F --glob "*.rb" --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

nmap <Leader>sw :execute 'RgExact ' . expand('<cword>') <Cr>
nmap <Leader>sW :execute 'RgExact ' . expand('<cWORD>') <Cr>

" Easier navigation between split windows
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Map H/L to move to the beginning/end of a line
nnoremap H ^
nnoremap L g_

" Copy current filename to clipboard
nnoremap <silent> <leader>cp :let @+ = expand("%")<CR>

nmap <leader>cm a<C-v>u2713<esc>

nmap <leader>pr :silent !dev open pr<CR>

nmap <leader>dt :VimuxRunCommand 'dev test --include-branch-commits'<CR>
nmap <leader>dr :VimuxRunCommand 'dev style --include-branch-commits'<CR>
nmap <leader>ds :VimuxRunCommand './bin/srb typecheck'<CR>
nmap <leader>da :VimuxRunCommand 'clear ; dev style --include-branch-commits && ./bin/srb typecheck && dev test --include-branch-commits'<CR>

" paste with indenting, https://github.com/sickill/vim-pasta
nnoremap <leader>p p`[v`]=

nnoremap gv :only<bar>vsplit<CR>gf

" Keep it centered
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" undo breakpoints
inoremap , ,<c-g>u
inoremap . .<c-g>u

" moving text
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
inoremap <C-k> <esc>:m .-2<CR>==
inoremap <C-j> <esc>:m .+1<CR>==

" moving splits
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

augroup MyOverrides
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e " trim whitespace
  autocmd BufWritePost ~/Documents/TODO.md silent! :!pandoc -s -o ~/Documents/todo.html --from=markdown ~/Documents/TODO.md
augroup END

nnoremap <leader>todo :edit ~/Documents/TODO.md<CR>
nnoremap <leader>htodo :!open ~/Documents/todo.html<CR>

" ---------------------------------------------------
" Plugins
" ---------------------------------------------------
source ~/.config/nvim/extras/auto_install_vim-plug.vim

call plug#begin(data_dir . '/plugins')

source ~/.config/nvim/plugins/bufferline.vim
source ~/.config/nvim/plugins/fugitive.vim
source ~/.config/nvim/plugins/fzf.vim
source ~/.config/nvim/plugins/gruvbox.vim
source ~/.config/nvim/plugins/lualine.vim
source ~/.config/nvim/plugins/nvim-cmp.vim
source ~/.config/nvim/plugins/nvim-lsp.vim
source ~/.config/nvim/plugins/obsession.vim
source ~/.config/nvim/plugins/splitjoin.vim
source ~/.config/nvim/plugins/tmux-navigator.vim
source ~/.config/nvim/plugins/vim-coauthors.vim
source ~/.config/nvim/plugins/vim-sorbet.vim
source ~/.config/nvim/plugins/vim-test.vim
source ~/.config/nvim/plugins/vim-vinegar.vim
source ~/.config/nvim/plugins/vimux.vim
source ~/.config/nvim/plugins/which-key.vim
source ~/.config/nvim/plugins/projectionist.vim
source ~/.config/nvim/plugins/ultisnips.vim
source ~/.config/nvim/plugins/zzz-vim-devicons.vim

Plug 'tpope/vim-commentary'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()
oautocmd User PlugLoaded

source ~/.config/nvim/extras/dim_inactive_windows.vim
source ~/.config/nvim/extras/relative_numbers.vim
" source ~/.config/nvim/extras/av_using_fzf.vim

Plug 'vim-test/vim-test'

nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestNearest<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>

nmap <silent> <leader>tr :VimuxRunCommand 'dev retest'<CR>

nmap <silent> <leader>f :TestFile<CR>
nmap <silent> <leader>s :TestNearest<CR>

if exists('$TMUX')
  let test#strategy = "vimux"
else
  let test#strategy = "dispatch"
end

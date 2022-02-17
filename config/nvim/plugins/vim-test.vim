Plug 'vim-test/vim-test'

nmap <silent> <leader>tn :TestNearest<CR>
nmap <silent> <leader>tf :TestFile<CR>
nmap <silent> <leader>ts :TestNearest<CR>
nmap <silent> <leader>tl :TestLast<CR>
nmap <silent> <leader>tv :TestVisit<CR>

nmap <silent> <leader>f :TestFile<CR>
nmap <silent> <leader>s :TestNearest<CR>

let test#strategy = "vimux"


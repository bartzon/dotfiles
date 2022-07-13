Plug 'nvim-lua/plenary.nvim'
Plug 'ThePrimeagen/harpoon'

lua<<EOF
function setup_harpoon() 
  require("harpoon").setup {
    menu = {
      width = vim.api.nvim_win_get_width(0) - 4,
    },
    global_settings = {
      mark_branch = true,
    },
  }
end
EOF

augroup IndentOverride
  autocmd User PlugLoaded ++nested lua setup_harpoon()
augroup end

nnoremap <leader>hl :lua require("harpoon.ui").toggle_quick_menu()<CR>
nnoremap <leader>ha :lua require("harpoon.mark").add_file()<CR>

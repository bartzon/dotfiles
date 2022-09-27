Plug 'anuvyklack/middleclass'
Plug 'anuvyklack/windows.nvim'

lua<<EOF
function windows_setup()
  require("windows").setup({
     autowidth = {
        enable = true,
        winwidth = 5,
        filetype = {
           help = 2,
        },
     },
     ignore = {
        buftype = { "quickfix" },
        filetype = { "NvimTree", "neo-tree", "undotree", "gundo" }
     },
     animation = {
        enable = true,
        duration = 300,
        fps = 30,
        easing = "in_out_sine"
     }
  })
end
EOF

augroup WindowsSetup
  autocmd User PlugLoaded ++nested lua windows_setup()
augroup end

nnoremap <C-w>z :WindowsMaximize<CR>

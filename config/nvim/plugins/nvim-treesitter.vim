Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'omnisyle/nvim-hidesig'

lua<<EOF
function setup_treesitter()
  require'nvim-treesitter.configs'.setup {
    ensure_installed = { "ruby", "lua", "javascript", "vim", "yaml", "tsx" },
    -- highlight = {
    --   enable = true,
    -- },
    autopairs = { enable = true },
    autotag = { enable = true, disable = { 'markdown' } },
    context_commentstring = { enable = true, enable_autocmd = false },
    rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
    hidesig = {
      enable = true,
      opacity = 0.5,
      delay = 200,
    }
  }
end
EOF

augroup TreesitterSetup
  autocmd User PlugLoaded ++nested lua setup_treesitter()
augroup end



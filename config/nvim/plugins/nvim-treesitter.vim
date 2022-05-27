Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

lua<<EOF
function setup_treesitter()
  require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = { "ruby", "lua", "javascript", "vim", "yaml", "tsx" },
    highlight = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
    },
    autopairs = { enable = true },
    autotag = { enable = true, disable = { 'markdown' } },
    context_commentstring = { enable = true, enable_autocmd = false },
    rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
  }
end
EOF

augroup TreesitterSetup
  autocmd User PlugLoaded ++nested lua setup_treesitter()
augroup end



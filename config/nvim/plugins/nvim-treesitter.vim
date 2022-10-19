Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'omnisyle/nvim-hidesig'

lua<<EOF
function setup_treesitter()
  require'nvim-treesitter.configs'.setup {
    ensure_installed = { "ruby", "lua", "javascript", "vim", "yaml", "tsx" },
    highlight = {
      enable = false,
    },
    autopairs = { enable = true },
    autotag = { enable = true, disable = { 'markdown' } },
    context_commentstring = { enable = true, enable_autocmd = false },
    rainbow = { enable = true, extended_mode = true, max_file_lines = 1000 },
    hidesig = {
      enable = true,
      opacity = 0.5,
      delay = 200,
    },
    textobjects = {
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          ["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
          ["if"] = { query = "@function.inner", desc = "Select inner part of a function region" },
          ["af"] = { query = "@function.outer", desc = "Select outer part of a function region" },
          ["ib"] = { query = "@block.inner", desc = "Select inner part of a block region" },
          ["ab"] = { query = "@block.outer", desc = "Select outer part of a block region" },
        },
        include_surrounding_whitespace = true,
      },
    },
  }
end
EOF

augroup TreesitterSetup
  autocmd User PlugLoaded ++nested lua setup_treesitter()
augroup end



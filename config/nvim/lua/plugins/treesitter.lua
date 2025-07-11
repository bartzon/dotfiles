return {
  'nvim-treesitter/nvim-treesitter',
  event = "BufReadPre",
  dependencies = {
    { 'nvim-treesitter/nvim-treesitter-textobjects' },
    { 'nvim-treesitter/nvim-treesitter-context' },
    { 'andymass/vim-matchup' },
  },
  opts = {
    highlight = {
      enable = true,
      -- disable = {
      --   "ruby",
      -- }
    },
    auto_install = true,
    autopairs = {
      enable = true
    },
    indent = {
      enable = true,
    },
    matchup = {
      enable = true,
    },
    move = {
      enable = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
      }
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<CR>',
        node_incremental = '<C-j>',
        node_decremental = '<C-k>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['if'] = '@function.inner',
          ['af'] = '@function.outer',
          ['ic'] = '@class.inner',
          ['ac'] = '@class.outer',
          ['ib'] = '@block.inner',
          ['ab'] = '@block.outer',
        },
        include_surrounding_whitespace = true,
      },
    },
    ensure_installed = {
      'ruby',
      'javascript',
      'typescript',
      'tsx',
      'css',
      'json',
      'lua',
      'vim',
      'kotlin',
      'bash',
      'html',
      'yaml',
      'markdown',
      'vimdoc',
    },
  },
  build = function()
    pcall(vim.cmd, 'TSUpdate')
  end,
  config = function(_, opts)
    require('nvim-treesitter.configs').setup(opts)
    require('treesitter-context').setup()
  end,
}

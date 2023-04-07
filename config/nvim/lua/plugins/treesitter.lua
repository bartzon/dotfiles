local Plugin = { 'nvim-treesitter/nvim-treesitter' }
Plugin.pin = true

Plugin.dependencies = {
  { 'nvim-treesitter/nvim-treesitter-textobjects', pin = true },
  { 'omnisyle/nvim-hidesig' },
  { 'nvim-treesitter/nvim-treesitter-context' },
  { 'andymass/vim-matchup' },
}

Plugin.opts = {
  highlight = {
    enable = false,
  },
  autopairs = {
    enable = true
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
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = 1000,
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
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
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
  },
  hidesig = {
    enable = true,
    opacity = 0.75,
    delay = 200,
  }
}

function Plugin.build()
  pcall(vim.cmd, 'TSUpdate')
end

function Plugin.config(_, opts)
  require('nvim-treesitter.configs').setup(opts)
  require('treesitter-context').setup()
end

return Plugin

return {
  'neovim/nvim-lspconfig',
  cmd = 'LspInfo',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'williamboman/mason-lspconfig.nvim' },
    { 'williamboman/mason.nvim' },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    { 'pmizio/typescript-tools.nvim' },
    { 'folke/lazydev.nvim' },
  },
  config = function()
    require('typescript-tools').setup {  }
    require('lazydev').setup {  }

    local lsp = require('lspconfig')

    require('mason').setup()
    require('mason-lspconfig').setup {
      ensure_installed = {
        'ruby_lsp',
        'sorbet',
        'kotlin_language_server',
      },
    }
    require('mason-tool-installer').setup {
      ensure_installed = {
        'prettier',
        'eslint',
        'rubocop',
        'eslint_d',
        'vimls',
      }
    }

    lsp.sorbet.setup {}
    lsp.ruby_lsp.setup {}
    lsp.lua_ls.setup {}
    lsp.rubocop.setup {}
    lsp.kotlin_language_server.setup {}
  end
}

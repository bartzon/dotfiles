local Plugin = {
  'neovim/nvim-lspconfig',
}

Plugin.cmd = 'LspInfo'
Plugin.event = { 'BufReadPre', 'BufNewFile' }

Plugin.dependencies = {
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'williamboman/mason-lspconfig.nvim' },
  { 'williamboman/mason.nvim' },
  { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
  { 'pmizio/typescript-tools.nvim' },
  { 'folke/lazydev.nvim' },
}

function Plugin.config()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  require('typescript-tools').setup { capabilities = capabilities }
  require('lazydev').setup { capabilities = capabilities }

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
      'tsserver',
      'eslint_d',
      'vimls',
    }
  }

  lsp.sorbet.setup { capabilities = capabilities }
  lsp.ruby_lsp.setup { capabilities = capabilities }
  lsp.lua_ls.setup { capabilities = capabilities }
  lsp.rubocop.setup { capabilities = capabilities }
  lsp.kotlin_language_server.setup { capabilities = capabilities }
end

return Plugin

local Plugin = {
  'neovim/nvim-lspconfig',
}

Plugin.cmd = 'LspInfo'
Plugin.event = { 'BufReadPre', 'BufNewFile' }

Plugin.dependencies = {
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'williamboman/mason-lspconfig.nvim' },
  {
    'williamboman/mason.nvim',
    build = function()
      pcall(vim.cmd, 'MasonUpdate')
    end,
  },
  { 'pmizio/typescript-tools.nvim' },
  { 'folke/neodev.nvim' },
}

function Plugin.config()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  require('typescript-tools').setup {capabilities = capabilities}
  require("neodev").setup {capabilities = capabilities}

  local lsp = require('lspconfig')

  require('mason').setup()
  require("mason-lspconfig").setup {
    ensure_installed = {
      'ruby_ls',
      'sorbet',
      'rubocop',
      'lua_ls',
    },
  }

  lsp.sorbet.setup {capabilities = capabilities}
  lsp.ruby_ls.setup {capabilities = capabilities}
  lsp.lua_ls.setup {capabilities = capabilities}
  lsp.rubocop.setup {capabilities = capabilities}
end

vim.diagnostic.config({
  virtual_text = true,
  focusable = false,
})

return Plugin

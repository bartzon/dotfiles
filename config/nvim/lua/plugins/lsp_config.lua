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
}

function Plugin.config()
  local lsp = require('lsp-zero')

  lsp.ensure_installed({
    -- Replace these with whatever servers you want to install
    'sorbet',
    'ruby-lsp',
    'rubocop'
  })

  lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
  end)

  require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

  lsp.setup()
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "none",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "none",
})

vim.diagnostic.config({
  virtual_text = true
})

return Plugin

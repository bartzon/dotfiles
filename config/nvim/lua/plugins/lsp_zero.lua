local Plugin = {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  lazy = true,
}

Plugin.dependencies = {
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'williamboman/mason-lspconfig.nvim' },
  {
    'williamboman/mason.nvim',
    build = function()
      pcall(vim.cmd, 'MasonUpdate')
    end,
  },
  { 'jose-elias-alvarez/typescript.nvim' },
}

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local lsp_format_on_save = function(bufnr)
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format()
    end,
  })
end

function Plugin.config()
  local lsp = require('lsp-zero').preset('recommended')

  lsp.ensure_installed({
    'sorbet',
    'ruby-lsp',
    'rubocop',
    'tsserver',
    'kotlin',
  })

  lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    lsp.format_on_save({
      lsp_format_on_save(bufnr)
    })
  end)

  lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
  })

  lsp.setup()

  require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
  require('lspconfig').sorbet.setup({})
  require('lspconfig').ruby_ls.setup({})
  require('lspconfig').tsserver.setup({})
  require('lspconfig').kotlin_language_server.setup({})
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "none",
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = "none",
})

vim.diagnostic.config({
  virtual_text = true,
  focusable = false,
})

return Plugin

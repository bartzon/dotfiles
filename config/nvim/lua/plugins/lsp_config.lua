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
  { 'jose-elias-alvarez/typescript.nvim' },
}

function Plugin.config()
  local lsp = require('lsp-zero')

  lsp.ensure_installed({
    'sorbet',
    'ruby-lsp',
    'rubocop',
    'tsserver',
  })

  lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
  end)

  require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
  require('typescript').setup({
    disable_commands = false, -- prevent the plugin from creating Vim commands
    debug = false,            -- enable debug logging for commands
    go_to_source_definition = {
      fallback = true,        -- fall back to standard LSP definition on failure
    },
  })

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

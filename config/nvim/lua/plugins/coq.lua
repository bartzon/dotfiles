return {
  'neovim/nvim-lspconfig',
  lazy = false,
  dependencies = {
    { 'ms-jpq/coq_nvim', branch = 'coq' },
    { 'ms-jpq/coq.thirdparty', branch = '3p' }
  },
  init = function()
    vim.g.coq_settings = {
      auto_start = true,
      display = {
        preview = {
          border = "solid",
          positions = {
            north = 4, west = 4, south = 4, east = 1
          }
        }
      },
    }
  end,
  config = function()
    require('coq_3p') {
      { src = 'nvimlua', short_name = 'nLUA' },
      { src = 'copilot', short_name = 'COP', accept_key = '<c-f>' },
      { src = 'builtin/html' },
      { src = 'builtin/js' },
      { src = 'builtin/xml' },
      { src = 'builtin/css' },
      { src = 'builtin/syntax' },
    }

    local lsp = require "lspconfig"
    local coq = require "coq"

    lsp.tsserver.setup{}
    lsp.tsserver.setup(coq.lsp_ensure_capabilities{})
    vim.cmd('COQnow -s')
  end,
}


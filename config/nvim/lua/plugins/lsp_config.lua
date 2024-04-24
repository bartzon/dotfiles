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
  { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
  { 'pmizio/typescript-tools.nvim' },
  { 'folke/neodev.nvim' },
}

function Plugin.config()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  require('typescript-tools').setup { capabilities = capabilities }
  require("neodev").setup { capabilities = capabilities }

  local lsp = require('lspconfig')

  require('mason').setup()
  require("mason-lspconfig").setup {
    ensure_installed = {
      'ruby_lsp',
      'sorbet',
      'rubocop',
      'lua_ls',
      'kotlin-language-server',
    },
  }
  require("mason-tool-installer").setup {
    ensure_installed = {
      'vim-language-server',
      'prettier',
      'eslint',
      'rubocop',
    }
  }

  lsp.sorbet.setup { capabilities = capabilities }
  lsp.ruby_lsp.setup { capabilities = capabilities }
  lsp.lua_ls.setup { capabilities = capabilities }
  lsp.rubocop.setup { capabilities = capabilities }
  lsp.kotlin_language_server.setup { capabilities = capabilities }

  -- Function to check if a floating dialog exists and if not
  -- then check for diagnostics under the cursor
  function OpenDiagnosticIfNoFloat()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
      if vim.api.nvim_win_get_config(winid).zindex then
        return
      end
    end
    -- THIS IS FOR BUILTIN LSP
    vim.diagnostic.open_float(0, {
      scope = "cursor",
      focusable = false,
      close_events = {
        "CursorMoved",
        "CursorMovedI",
        "BufHidden",
        "InsertCharPre",
        "WinLeave",
      },
    })
  end

  -- Show diagnostics under the cursor when holding position
  vim.api.nvim_create_augroup("lsp_diagnostics_hold", { clear = true })
  vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = "*",
    command = "lua OpenDiagnosticIfNoFloat()",
    group = "lsp_diagnostics_hold",
  })
end

vim.diagnostic.config({
  virtual_text = true,
  focusable = false,
})

return Plugin

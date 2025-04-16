return {
  'neovim/nvim-lspconfig',
  cmd = 'LspInfo',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { 'williamboman/mason-lspconfig.nvim' },
    { 'williamboman/mason.nvim' },
    { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
    { 'pmizio/typescript-tools.nvim' },
    { 'folke/lazydev.nvim' },
  },
  config = function()
    require('typescript-tools').setup {}
    require('lazydev').setup {}

    local lsp = require('lspconfig')

    require('mason').setup()
    require('mason-lspconfig').setup {}
    require('mason-tool-installer').setup {
      ensure_installed = {
        'prettier',
        'eslint',
        'eslint_d',
        'vimls',
        'json-lsp',
        'lua-language-server',
        'typescript-language-server',
        'css-lsp',
      }
    }

    -- Helper function to check if local bin exists and use it, otherwise fall back to mason
    local function get_cmd(local_cmd, mason_cmd)
      local local_path = vim.fn.getcwd() .. "/" .. local_cmd[1]
      if vim.fn.filereadable(local_path) == 1 then
        return local_cmd
      else
        return mason_cmd
      end
    end

    lsp.sorbet.setup {
      cmd = get_cmd(
        { "./bin/srb", "tc", "--lsp" },
        { "srb", "tc", "--lsp" }
      )
    }
    lsp.ruby_lsp.setup {
      cmd = get_cmd(
        { "./bin/ruby-lsp" },
        { "ruby-lsp" }
      ),
      init_options = {
        enabledFeatureFlags = { ["tapiocaAddon"] = true }
      }
    }
    lsp.lua_ls.setup {}
    lsp.rubocop.setup {
      cmd = get_cmd(
        { "./bin/rubocop", "--lsp" },
        { "rubocop", "--lsp" }
      )
    }
  end
}

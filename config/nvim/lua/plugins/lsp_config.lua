return {
  'neovim/nvim-lspconfig',
  cmd = 'LspInfo',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { 'williamboman/mason.nvim' },
    { 'pmizio/typescript-tools.nvim' },
    { 'folke/lazydev.nvim' },
    { 'saghen/blink.cmp' },
  },
  config = function()
    require('typescript-tools').setup {}
    require('lazydev').setup {}

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    require('mason').setup()

    local function get_cmd(local_cmd, mason_cmd)
      local local_path = vim.fn.getcwd() .. "/" .. local_cmd[1]
      if vim.fn.filereadable(local_path) == 1 then
        return local_cmd
      else
        return mason_cmd
      end
    end

    local has_new_lsp_api = vim.fn.has('nvim-0.11') == 1 and
                            vim.lsp.config ~= nil and
                            vim.lsp.enable ~= nil

    if has_new_lsp_api then
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          if client.name == "rubocop" then
            client.server_capabilities.documentFormattingProvider = true
            local format = require('user.autocmds.formatting')
            format.setup_rubocop_formatting(client, bufnr)
          end
        end,
      })
    end

    local function rubocop_on_attach(client, bufnr)
      client.server_capabilities.documentFormattingProvider = true
      local format = require('user.autocmds.formatting')
      format.setup_rubocop_formatting(client, bufnr)
    end

    if has_new_lsp_api then
      -- Configure LSP servers with new API
      vim.lsp.config('sorbet', {
        capabilities = capabilities,
        cmd = get_cmd(
          { "./bin/srb", "tc", "--lsp" },
          { "srb", "tc", "--lsp" }
        )
      })

      vim.lsp.config('ruby_lsp', {
        capabilities = capabilities,
        cmd = get_cmd(
          { "./bin/ruby-lsp" },
          { "ruby-lsp" }
        ),
        init_options = {
          enabledFeatureFlags = {
            ["tapiocaAddon"] = true
          }
        }
      })

      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
      })

      vim.lsp.config('rubocop', {
        capabilities = capabilities,
        cmd = get_cmd(
          { "./bin/rubocop", "--lsp" },
          { "rubocop", "--lsp" }
        ),
        settings = {
          rubocop = { useBundler = false, lint = true, autocorrect = true }
        },
      })

      if vim.lsp.enable then
        vim.lsp.enable({'sorbet', 'ruby_lsp', 'lua_ls', 'rubocop'})
      else
        print("Warning: vim.lsp.enable not available, servers will auto-start if supported")
      end
    else
      local lspconfig = require('lspconfig')

      lspconfig.sorbet.setup {
        capabilities = capabilities,
        cmd = get_cmd(
          { "./bin/srb", "tc", "--lsp" },
          { "srb", "tc", "--lsp" }
        )
      }

      lspconfig.ruby_lsp.setup {
        capabilities = capabilities,
        cmd = get_cmd(
          { "./bin/ruby-lsp" },
          { "ruby-lsp" }
        ),
        init_options = {
          enabledFeatureFlags = {
            ["tapiocaAddon"] = true
          }
        }
      }

      lspconfig.lua_ls.setup {
        capabilities = capabilities,
      }

      lspconfig.rubocop.setup {
        capabilities = capabilities,
        cmd = get_cmd(
          { "./bin/rubocop", "--lsp" },
          { "rubocop", "--lsp" }
        ),
        settings = {
          rubocop = {
            useBundler = false,
            lint = true,
            autocorrect = true
          }
        },
        on_attach = rubocop_on_attach
      }
    end
  end
}

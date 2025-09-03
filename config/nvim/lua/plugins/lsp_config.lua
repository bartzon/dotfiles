return {
  'neovim/nvim-lspconfig',
  cmd = 'LspInfo',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'pmizio/typescript-tools.nvim' },
    { 'folke/lazydev.nvim' },
    { 'saghen/blink.cmp' },
  },
  config = function()
    require('typescript-tools').setup({
      -- Disable typescript-tools formatting since we're using prettier
      settings = {
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        tsserver_format_options = {
          allowIncompleteCompletions = false,
          allowRenameOfImportPath = false,
        },
      },
    })
    require('lazydev').setup({})

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local function get_cmd(local_cmd, mason_cmd)
      local local_path = vim.fn.getcwd() .. '/' .. local_cmd[1]
      if vim.fn.filereadable(local_path) == 1 then
        return local_cmd
      else
        return mason_cmd
      end
    end

    local has_new_lsp_api = vim.fn.has('nvim-0.11') == 1 and vim.lsp.config ~= nil and vim.lsp.enable ~= nil

    if has_new_lsp_api then
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local bufnr = args.buf

          if client.name == 'rubocop' then
            client.server_capabilities.documentFormattingProvider = true
            local format = require('user.autocmds.formatting')
            format.setup_rubocop_formatting(client, bufnr)
          end
          
          -- Disable formatting for typescript-tools and eslint
          if client.name == 'typescript-tools' or client.name == 'eslint' then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        end,
      })
    end

    local function rubocop_on_attach(client, bufnr)
      client.server_capabilities.documentFormattingProvider = true
      local format = require('user.autocmds.formatting')
      format.setup_rubocop_formatting(client, bufnr)
    end
    
    local function typescript_on_attach(client, bufnr)
      -- Disable formatting capabilities for TypeScript LSP
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end
    
    local function eslint_on_attach(client, bufnr)
      -- Disable formatting capabilities for ESLint LSP
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end

    if has_new_lsp_api then
      -- Configure LSP servers with new API
      vim.lsp.config('sorbet', {
        capabilities = capabilities,
        cmd = get_cmd({ './bin/srb', 'tc', '--lsp' }, { 'srb', 'tc', '--lsp' }),
      })

      vim.lsp.config('ruby_lsp', {
        capabilities = capabilities,
        cmd = get_cmd({ './bin/ruby-lsp' }, { 'ruby-lsp' }),
        init_options = {
          enabledFeatureFlags = {
            ['tapiocaAddon'] = true,
          },
        },
      })

      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
      })

      vim.lsp.config('rubocop', {
        capabilities = capabilities,
        cmd = get_cmd({ './bin/rubocop', '--lsp' }, { 'rubocop', '--lsp' }),
        settings = {
          rubocop = { useBundler = false, lint = true, autocorrect = true },
        },
      })
      
      vim.lsp.config('eslint', {
        capabilities = capabilities,
        cmd = { 'vscode-eslint-language-server', '--stdio' },
        settings = {
          nodePath = vim.fn.getcwd() .. '/node_modules',
          workingDirectory = { mode = 'location' },
          codeAction = {
            disableRuleComment = {
              enable = true,
              location = 'separateLine'
            },
            showDocumentation = {
              enable = true
            }
          },
          codeActionOnSave = {
            enable = false,
            mode = 'all'
          },
          format = false,
          quiet = false,
          onIgnoredFiles = 'off',
          rulesCustomizations = {},
          run = 'onType',
          validate = 'on',
        },
      })

      if vim.lsp.enable then
        vim.lsp.enable({ 'sorbet', 'ruby_lsp', 'lua_ls', 'rubocop', 'typescript-tools', 'eslint' })
      else
        print('Warning: vim.lsp.enable not available, servers will auto-start if supported')
      end
    else
      local lspconfig = require('lspconfig')

      lspconfig.sorbet.setup({
        capabilities = capabilities,
        cmd = get_cmd({ './bin/srb', 'tc', '--lsp' }, { 'srb', 'tc', '--lsp' }),
      })

      lspconfig.ruby_lsp.setup({
        capabilities = capabilities,
        cmd = get_cmd({ './bin/ruby-lsp' }, { 'ruby-lsp' }),
        init_options = {
          enabledFeatureFlags = {
            ['tapiocaAddon'] = true,
          },
        },
      })

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      lspconfig.rubocop.setup({
        capabilities = capabilities,
        cmd = get_cmd({ './bin/rubocop', '--lsp' }, { 'rubocop', '--lsp' }),
        settings = {
          rubocop = {
            useBundler = false,
            lint = true,
            autocorrect = true,
          },
        },
        on_attach = rubocop_on_attach,
      })
      
      -- ESLint configuration for older nvim versions
      lspconfig.eslint.setup({
        capabilities = capabilities,
        on_attach = eslint_on_attach,
        settings = {
          nodePath = vim.fn.getcwd() .. '/node_modules',
          workingDirectory = { mode = 'location' },
          codeAction = {
            disableRuleComment = {
              enable = true,
              location = 'separateLine'
            },
            showDocumentation = {
              enable = true
            }
          },
          codeActionOnSave = {
            enable = false,
            mode = 'all'
          },
          format = false,
          quiet = false,
          onIgnoredFiles = 'off',
          rulesCustomizations = {},
          run = 'onType',
          validate = 'on',
        },
      })
    end
  end,
}
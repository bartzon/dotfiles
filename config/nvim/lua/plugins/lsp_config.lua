return {
  'folke/lazydev.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { 'saghen/blink.cmp' },
  },
  config = function()
    require('lazydev').setup {}

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    -- Load all LSP configurations from the lsp directory
    local lsp_configs = vim.fn.glob(vim.fn.stdpath('config') .. '/lua/lsp/*.lua', true, true)

    for _, config_path in ipairs(lsp_configs) do
      local server_name = vim.fn.fnamemodify(config_path, ':t:r')
      local ok, config = pcall(require, 'lsp.' .. server_name)

      if ok then
        -- Add capabilities to each config
        config.capabilities = capabilities

        -- Resolve cmd if it's a function
        if type(config.cmd) == 'function' then
          local cmd_func = config.cmd
          local cmd_ok, cmd_result = pcall(cmd_func)
          if cmd_ok then
            config.cmd = cmd_result
          else
            vim.notify('Failed to resolve cmd for ' .. server_name .. ': ' .. tostring(cmd_result), vim.log.levels.WARN)
            goto continue
          end
        end

        -- Register the LSP configuration
        vim.lsp.config(server_name, config)
      else
        vim.notify('Failed to load LSP config for ' .. server_name, vim.log.levels.ERROR)
      end
      ::continue::
    end

    -- Set up LspAttach autocommand for server-specific configurations
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        -- Handle special on_attach logic
        if client.name == "rubocop" then
          client.server_capabilities.documentFormattingProvider = true
          local format = require('user.autocmds.formatting')
          format.setup_rubocop_formatting(client, bufnr)
        end

        -- Enable inlay hints if supported (Neovim 0.10+)
        if client.supports_method('textDocument/inlayHint') then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        -- Enable semantic tokens if supported
        if client.supports_method('textDocument/semanticTokens/full') then
          vim.lsp.semantic_tokens.start(bufnr, client.id)
        end
      end,
    })

    -- Set up format on save
    local format_on_save = vim.api.nvim_create_augroup('FormatOnSave', { clear = true })

    -- Configure format on save for specific filetypes
    vim.g.format_on_save_enabled = true
    local format_filetypes = {
      lua = true,
      ruby = true,
      typescript = true,
      typescriptreact = true,
      javascript = true,
      javascriptreact = true,
    }

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = format_on_save,
      pattern = '*',
      callback = function(args)
        local filetype = vim.bo[args.buf].filetype

        -- Check if format on save is enabled and this filetype should be formatted
        if not vim.g.format_on_save_enabled or not format_filetypes[filetype] then
          return
        end

        -- Get available LSP clients for this buffer
        local clients = vim.lsp.get_clients({ bufnr = args.buf })

        -- Filter to only clients that support formatting
        local formatting_clients = vim.tbl_filter(function(client)
          return client.supports_method('textDocument/formatting')
        end, clients)

        if #formatting_clients == 0 then
          return
        end

        -- Format the buffer
        vim.lsp.buf.format({
          bufnr = args.buf,
          timeout_ms = 2000,
          filter = function(client)
            -- For Ruby files, prefer rubocop
            if filetype == 'ruby' and client.name == 'rubocop' then
              return true
            elseif filetype == 'ruby' and client.name ~= 'rubocop' then
              -- Check if rubocop is available
              local has_rubocop = vim.tbl_contains(
                vim.tbl_map(function(c) return c.name end, formatting_clients),
                'rubocop'
              )
              return not has_rubocop
            end

            -- For other filetypes, use any formatter
            return client.supports_method('textDocument/formatting')
          end,
        })
      end,
      desc = 'Format on save using LSP',
    })

    -- Create commands to toggle format on save
    vim.api.nvim_create_user_command('FormatOnSaveEnable', function()
      vim.g.format_on_save_enabled = true
      vim.notify('Format on save enabled', vim.log.levels.INFO)
    end, { desc = 'Enable format on save' })

    vim.api.nvim_create_user_command('FormatOnSaveDisable', function()
      vim.g.format_on_save_enabled = false
      vim.notify('Format on save disabled', vim.log.levels.INFO)
    end, { desc = 'Disable format on save' })

    vim.api.nvim_create_user_command('FormatOnSaveToggle', function()
      vim.g.format_on_save_enabled = not vim.g.format_on_save_enabled
      local status = vim.g.format_on_save_enabled and 'enabled' or 'disabled'
      vim.notify('Format on save ' .. status, vim.log.levels.INFO)
    end, { desc = 'Toggle format on save' })

    -- Enable all configured LSP servers
    -- Check if vim.lsp.enable exists (newer Neovim versions)
    if vim.lsp.enable then
      for _, config_path in ipairs(lsp_configs) do
        local server_name = vim.fn.fnamemodify(config_path, ':t:r')
        local ok, err = pcall(vim.lsp.enable, server_name)
        if not ok then
          vim.notify('Failed to enable LSP ' .. server_name .. ': ' .. tostring(err), vim.log.levels.WARN)
        end
      end
    else
      -- Fallback for older Neovim versions: Set up autocommands to start servers manually
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function(args)
          for _, config_path in ipairs(lsp_configs) do
            local server_name = vim.fn.fnamemodify(config_path, ':t:r')
            local config = vim.lsp.config[server_name]
            if config and vim.tbl_contains(config.filetypes or {}, args.match) then
              local start_config = vim.tbl_deep_extend('force', config, {
                name = server_name,
                root_dir = vim.fs.root(args.buf, config.root_markers or { '.git' })
              })

              -- Check if this server is already running for this buffer
              local clients = vim.lsp.get_clients({ bufnr = args.buf, name = server_name })
              if #clients == 0 then
                vim.lsp.start(start_config)
              end
            end
          end
        end,
      })
    end

    -- Set up diagnostics configuration
    vim.diagnostic.config({
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '✘',
          [vim.diagnostic.severity.WARN] = '▲',
          [vim.diagnostic.severity.HINT] = '⚡',
          [vim.diagnostic.severity.INFO] = '»',
        },
      },
    })

    -- Set up hover and signature help with borders
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = "rounded",
      }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = "rounded",
      }
    )

    -- Configure completion item kinds
    local kind_icons = {
      Text = "󰉿",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰜢",
      Variable = "󰀫",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "󰑭",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "󰈇",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "󰙅",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "",
    }

    -- Override the default completion formatting
    local cmp_kinds = vim.lsp.protocol.CompletionItemKind
    for i, kind in ipairs(cmp_kinds) do
      cmp_kinds[i] = kind_icons[kind] or kind
    end
  end
}

local Plugin = {'neovim/nvim-lspconfig'}
local user = {}

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

local signs = {
  Error = "",
  Warn = "",
  Hint = "",
  Info = "",
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
end

Plugin.dependencies = {
  {'j-hui/fidget.nvim'},
  {'williamboman/mason.nvim'},
  {'williamboman/mason-lspconfig.nvim'},
  {'hrsh7th/cmp-nvim-lsp'},
  {'ErichDonGubler/lsp_lines.nvim'},
}

Plugin.cmd = 'Lsp'

function Plugin.config()
  user.diagnostics()
  user.handlers()

  require('fidget').setup({})

  require('mason').setup({
    ui = {border = 'rounded'}
  })

  require('mason-lspconfig').setup({})

  require("lsp_lines").setup()

  vim.api.nvim_create_user_command(
    'Lsp',
    function(input)
      if input.args == '' then
        return
      end

      require('plugins.lsp.server').start(input.args, {})
    end,
    {desc = 'Initialize a language server', nargs = '?'}
  )
end

function Plugin.init()
  require'lspconfig'.sorbet.setup({
    cmd = { './bin/srb', 'tc', '--lsp' }
  })
end

function user.diagnostics()
  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd

  local sign = function(opts)
    vim.fn.sign_define(opts.name, {
      texthl = opts.name,
      text = opts.text,
      numhl = '',
    })
  end

  sign({name = 'DiagnosticSignError', text = '✘'})
  sign({name = 'DiagnosticSignWarn', text = '▲'})
  sign({name = 'DiagnosticSignHint', text = '⚑'})
  sign({name = 'DiagnosticSignInfo', text = '»'})

  vim.diagnostic.config({
    virtual_text = false,
  })

  local group = augroup('diagnostic_cmds', {clear = true})

  autocmd('ModeChanged', {
    group = group,
    pattern = {'n:i', 'v:s'},
    desc = 'Disable diagnostics while typing',
    callback = function() vim.diagnostic.disable(0) end
  })

  autocmd('ModeChanged', {
    group = group,
    pattern = 'i:n',
    desc = 'Enable diagnostics when leaving insert mode',
    callback = function() vim.diagnostic.enable(0) end
  })
end

function user.handlers()
  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  {border = 'rounded'}
  )

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  {border = 'rounded'}
  )

  local function goto_definition(split_cmd)
    local util = vim.lsp.util
    local log = require("vim.lsp.log")
    local api = vim.api

    local handler = function(_, result, ctx)
      if result == nil or vim.tbl_isempty(result) then
        local _ = log.info() and log.info(ctx.method, "No location found")
        return nil
      end

      if split_cmd then
        vim.cmd(split_cmd)
      end

      if vim.tbl_islist(result) then
        util.jump_to_location(result[1])

        if #result > 1 then
          util.set_qflist(util.locations_to_items(result))
          api.nvim_command("copen")
          api.nvim_command("wincmd p")
        end
      else
        util.jump_to_location(result)
      end
    end

    return handler
  end

  vim.lsp.handlers["textDocument/definition"] = goto_definition('split')

  local group = augroup('lsp_cmds', {clear = true})
  autocmd('LspAttach', {group = group, callback = user.lsp_attach})
end

function user.lsp_attach()
  if vim.b.lsp_attached then
    return
  end

  vim.b.lsp_attached = true

  local telescope = require('telescope.builtin')
  local lsp = vim.lsp.buf
  local bind = vim.keymap.set
  local command = vim.api.nvim_buf_create_user_command

  command(0, 'LspFormat', function()
    vim.lsp.buf.format({async = true})
  end, {})

  local opts = {silent = true, buffer = true}

  if vim.fn.mapcheck('gq', 'n') == '' then
    bind({'n', 'x'}, 'gq', '<cmd>LspFormat<cr>', opts)
  end

  bind('n', 'K', lsp.hover, opts)
  bind('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
  bind('n', 'gD', lsp.declaration, opts)
  bind('n', 'gi', '<cmd>Telescope lsp_implementation', opts)
  bind('n', 'go', lsp.type_definition, opts)
  bind('n', 'gr', '<cmd>Telescope lsp_references', opts)
  bind('n', 'gs', lsp.signature_help, opts)
  bind('n', '<F2>', lsp.rename, opts)
  bind('n', '<F4>', lsp.code_action, opts)

  bind('n', 'gl', vim.diagnostic.open_float, opts)
  bind('n', '[d', vim.diagnostic.goto_prev, opts)
  bind('n', ']d', vim.diagnostic.goto_next, opts)

  bind('n', '<leader>fd', telescope.lsp_document_symbols, opts)
  bind('n', '<leader>fq', telescope.lsp_workspace_symbols, opts)
end

return Plugin


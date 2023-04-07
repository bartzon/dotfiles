local Plugin = { 'folke/noice.nvim' }

Plugin.dependencies = {
  'MunifTanjim/nui.nvim',
  'rcarriga/nvim-notify',
}

Plugin.opts = {
  cmdline = {
    enabled = true,
    view = "cmdline",
  },
  lsp = {
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
      ['cmp.entry.get_documentation'] = true,
    },
    signature = {
      enabled = false
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
  },
  messages = {
    enabled = false,
  },
}

return Plugin

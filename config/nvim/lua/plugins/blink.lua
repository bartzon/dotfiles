-- vimperlfile.o.completion.list.selection = "manual"

return {
  'saghen/blink.cmp',
  version = '*',
  opts = {
    keymap = {
      preset = 'default',
      ['<Esc>'] = { 'fallback' },
      ['<Tab>'] = { 'show', 'select_next', 'fallback'},
      ['<CR>'] = { 'select_and_accept', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'cmdline' },
      cmdline = {},
    },
    signature = { enabled = true }
  },
}

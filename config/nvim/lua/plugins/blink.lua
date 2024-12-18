-- vim.o.completion.list.selection = "manual"

return {
  'saghen/blink.cmp',
  lazy = false,
  version = 'v0.*',
  opts = {
    keymap = {
      ['Esc'] = { 'close', 'fallback' },
      ['<CR>'] = { 'select_and_accept', 'fallback' },
      ['<Tab>'] = { 'show', 'select_next', 'fallback'},
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer', 'cmdline' },
    },
    signature = { enabled = true }
  },
}

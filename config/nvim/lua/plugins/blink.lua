return {
  'saghen/blink.cmp',
  opts = {
    keymap = {
      preset = 'default',
      ['<Esc>'] = { 'fallback' },
      ['<Tab>'] = { 'select_next', 'show', 'fallback' },
      ['<CR>'] = { 'select_and_accept', 'fallback' },
      ['<S-Tab>'] = { 'select_prev', 'fallback' },
      ['<C-n>'] = { 'snippet_forward', 'fallback' },
      ['<C-p>'] = { 'snippet_backward', 'fallback' },
      ['<leader>d'] = { 'show_documentation', 'hide_documentation', 'fallback' }
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = 'mono'
    },
    sources = {
      default = { 'lsp', 'path', 'buffer' },
    },
    cmdline = {
      sources = {},
    },
    completion = {
      documentation = {
        auto_show = false
      }
    },
    signature = {
      enabled = true,
      trigger = {
        enabled = true,
      },
      window = {
        treesitter_highlighting = true,
        show_documentation = true,
      }
    },
    fuzzy = {
      implementation = "lua",
    }
  }
}

local imap_expr = function(lhs, rhs)
  vim.keymap.set('i', lhs, rhs, { expr = true })
end
imap_expr('<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
imap_expr('<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

return {
  'echasnovski/mini.nvim',
  version = false,
  event = 'LspAttach',
  config = function()
    require('mini.completion').setup()
  end
}


-- vim.keymap.set('i', '<C-space>', '<Plug>(copilot-accept-word)')

return {
  'github/copilot.vim',
  event = 'BufEnter',
  cmd = 'Copilot',
  setup = function()
    require('copilot').setup()
    vim.keymap.set('i', '<C-space>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false
    })
    vim.g.copilot_no_tab_map = true
  end
}

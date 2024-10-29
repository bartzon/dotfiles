vim.keymap.set('i', '<C-space>', '<Plug>(copilot-accept-word)')

return {
  'github/copilot.vim',
  event = 'BufEnter',
  cmd = 'Copilot',
}

return {
  'github/copilot.vim',
  event = 'InsertEnter',
  config = function()
    vim.keymap.set('i', '<C-Space>', 'copilot#Accept("\\<CR>")', {
      expr = true,
      silent = true,
      replace_keycodes = false
    })
    vim.g.copilot_no_tab_map = true
  end
}


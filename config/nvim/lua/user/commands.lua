local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('init_cmds', { clear = true })

autocmd('TextYankPost', {
  desc = 'highlight text after is copied',
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 80 })
  end
})

autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  desc = 'Turn on relative numbers',
  group = augroup,
  command = 'set rnu'
})

autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  desc = 'Turn off relative numbers',
  group = augroup,
  command = 'set nornu'
})

autocmd('VimResized', {
  desc = 'Resize panes after host resize',
  group = augroup,
  command = 'wincmd = '
})

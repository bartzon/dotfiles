local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('init_cmds', { clear = true })

autocmd('TextYankPost', {
  desc = 'highlight text after is copied',
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 50 })
  end
})

autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  desc = 'Turn on relative numbers',
  group = augroup,
  callback = function()
    vim.cmd('set rnu')
  end
})

autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  desc = 'Turn off relative numbers',
  group = augroup,
  callback = function()
    vim.cmd('set nornu')
  end
})

autocmd('VimResized', {
  desc = 'Resize panes after host resize',
  group = augroup,
  command = 'wincmd = '
})

autocmd("FileType", {
  pattern = {
    "checkhealth",
    "fugitive*",
    "git",
    "help",
    "lspinfo",
    "netrw",
    "notify",
    "qf",
    "query",
  },
  callback = function()
    vim.keymap.set("n", "q", vim.cmd.close, { desc = "Close the current buffer", buffer = true })
  end,
})

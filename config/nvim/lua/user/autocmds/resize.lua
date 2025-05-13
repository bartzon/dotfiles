local M = {}

function M.setup()
  local augroup = vim.api.nvim_create_augroup('auto_resize', { clear = true })

  vim.api.nvim_create_autocmd('VimResized', {
    desc = 'Resize panes after host resize',
    group = augroup,
    command = 'wincmd = '
  })
end

return M

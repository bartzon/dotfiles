local M = {}

function M.setup()
  local augroup = vim.api.nvim_create_augroup('line_numbers_toggle', { clear = true })
  
  vim.api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
    desc = 'Turn on relative numbers',
    group = augroup,
    callback = function()
      vim.cmd('set rnu')
    end
  })
  
  vim.api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
    desc = 'Turn off relative numbers',
    group = augroup,
    callback = function()
      vim.cmd('set nornu')
    end
  })
end

return M

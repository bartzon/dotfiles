local M = {}

function M.setup()
  local augroup = vim.api.nvim_create_augroup('highlight_yank', { clear = true })

  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'highlight text after is copied',
    group = augroup,
    callback = function()
      vim.highlight.on_yank({ higroup = 'Visual', timeout = 50 })
    end
  })
end

return M

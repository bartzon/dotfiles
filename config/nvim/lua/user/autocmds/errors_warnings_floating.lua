local M = {}

function M.setup()
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      vim.diagnostic.open_float(nil, { focusable = false, source = "if_many" })
    end
  })
end

return M

local M = {}

function M.setup()
  local augroup = vim.api.nvim_create_augroup('buffer_mappings', { clear = true })
  
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
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
end

return M

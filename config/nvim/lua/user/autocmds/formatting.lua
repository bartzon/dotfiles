local M = {}

function M.setup()
end

function M.setup_rubocop_formatting(client, bufnr)
  local augroup = vim.api.nvim_create_augroup("RubocopFormatting", { clear = true })
  
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({
        bufnr = bufnr,
        filter = function(c)
          return c.name == "rubocop"
        end,
        timeout_ms = 2000
      })
    end,
    desc = "Format with Rubocop on save",
  })
end

return M

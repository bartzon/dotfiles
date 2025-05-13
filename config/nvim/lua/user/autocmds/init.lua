local M = {}

function M.setup()
  require('user.autocmds.highlights').setup()
  require('user.autocmds.line_numbers').setup()
  require('user.autocmds.resize').setup()
  require('user.autocmds.buffer_mappings').setup()
  require('user.autocmds.lsp_progress').setup()
end

return M

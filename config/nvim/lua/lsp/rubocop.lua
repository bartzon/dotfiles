return {
  cmd = function()
    local local_path = vim.fn.getcwd() .. "/bin/rubocop"
    if vim.fn.filereadable(local_path) == 1 then
      return { "./bin/rubocop", "--lsp" }
    else
      return { "rubocop", "--lsp" }
    end
  end,
  root_markers = { '.git', 'Gemfile', '.rubocop.yml' },
  filetypes = { 'ruby' },
  settings = {
    rubocop = { 
      useBundler = false, 
      lint = true, 
      autocorrect = true 
    }
  },
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    local format = require('user.autocmds.formatting')
    format.setup_rubocop_formatting(client, bufnr)
  end,
}

return {
  cmd = function()
    local local_path = vim.fn.getcwd() .. "/bin/ruby-lsp"
    if vim.fn.filereadable(local_path) == 1 then
      return { "./bin/ruby-lsp" }
    else
      return { "ruby-lsp" }
    end
  end,
  root_markers = { '.git', 'Gemfile' },
  filetypes = { 'ruby' },
  init_options = {
    enabledFeatureFlags = {
      ["tapiocaAddon"] = true
    }
  }
}
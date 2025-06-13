return {
  cmd = function()
    local local_path = vim.fn.getcwd() .. "/bin/srb"
    if vim.fn.filereadable(local_path) == 1 then
      return { "./bin/srb", "tc", "--lsp" }
    else
      return { "srb", "tc", "--lsp" }
    end
  end,
  root_markers = { '.git', 'Gemfile', 'sorbet' },
  filetypes = { 'ruby' },
}
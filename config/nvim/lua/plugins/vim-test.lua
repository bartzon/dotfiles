return {
  'vim-test/vim-test',
  init = function()
    vim.g['test#strategy'] = "vimux"
  end,
  keys = {
    { '<leader>tf', ":TestFile<CR>",    desc = "Test File" },
    { '<leader>ts', ":TestNearest<CR>", desc = "Test Nearest" },
    { '<leader>tl', ":VimuxRunCommand 'dev retest'<CR>", desc = "Retest" },
  },
}

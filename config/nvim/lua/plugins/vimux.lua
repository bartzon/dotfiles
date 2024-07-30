return {
  'preservim/vimux',
  init = function()
    vim.g.VimuxOrientation = "h"
  end,
  event = "VeryLazy",
  keys = {
    { "<leader>vo", "<cmd>:VimuxOpenRunner<CR>",          desc = "Open Vimux window" },
    { "<leader>du", "<cmd>:VimuxRunCommand 'dev up'<CR>", desc = "dev up" },
    { '<leader>dt', ":VimuxRunCommand 'dt'<CR>",          desc = "dev test" },
    { '<leader>dr', ":VimuxRunCommand 'dr'<CR>",          desc = "dev style" },
    { '<leader>ds', ":VimuxRunCommand 'ds'<CR>",          desc = "srb typecheck" },
    { '<leader>da', ":VimuxRunCommand 'da'<CR>",          desc = "dev all" },
  }
}

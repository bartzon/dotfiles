return {
  'folke/trouble.nvim',
  event = "VeryLazy",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  keys = {
    { "<leader>tt", "<cmdTrouble diagnostics toggle<CR>", desc = "Trouble diagnostics" },
    { "<leader>tq", "<cmd>Trouble quickfix toggle<CR>", desc = "Trouble quickfix" },
    {
      "<leader>tl",
      "<cmd>Trouble lsp toggle focus=false win = { type=split, position=right, size=0.30 }<cr>",
      desc = "Trouble LSP Definitions",
    },
  },
  opts = {
    position = "bottom",
    mode = "workspace_diagnostics",
  }
}

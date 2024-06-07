return {
  {
    "ramilito/winbar.nvim",
    event = "BufReadPre",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("winbar").setup({
        icons = true,
        diagnostics = true,
        buf_modified = true,
        buf_modified_symbol = "M",
        dim_inactive = {
          enabled = true,
          highlight = "WinbarNC",
          icons = true,
          name = true,
        }
      })
    end
  },
}

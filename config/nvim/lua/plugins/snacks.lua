return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    gitbrowse = { enabled = true },
    picker = {
      enabled = true,
      sources = {
        smart = { exclude = { "*.rbi" } },
        files = { exclude = { "*.rbi" } },
      },
    },
    zenmode = { enabled = true },
    indent = {
      enabled = true,
      animate = {
        enabled = true,
        duration = {
          step = 2,
          total = 25,
        },
      },
    },
    notifier = { enabled = true },
    words = { enabled = true },
  },
  keys = {
    {
      "<leader><leader>",
      function() Snacks.picker.smart() end,
      desc = "Smart Find Files"
    },
    {
      "<leader>sw",
      function() Snacks.picker.grep_word() end,
      desc = "Visual selection or word",
      mode = { "n", "x" }
    },
    {
      "<leader>fb",
      function() Snacks.picker.buffers() end,
      desc = "Buffers"
    },
    {
      "<leader>fs",
      function() Snacks.picker.lsp_symbols() end,
      desc = "LSP Symbols"
    },
    {
      'gd',
      function() 
        Snacks.picker.lsp_definitions({
          filter = {
            filter = function(item, self)
              return not (item.file and item.file:match("%.rbi$"))
            end,
          },
        })
      end,
      desc = "LSP Definitions"
    },
    {
      'gr',
      function() 
        Snacks.picker.lsp_references({
          filter = {
            filter = function(item, self)
              return not (item.file and item.file:match("%.rbi$"))
            end,
          },
        })
      end,
      desc = "LSP References"
    },
    {
      "<leader>gb",
      function() Snacks.gitbrowse() end,
      desc = "Git Browse",
      mode = { "n", "v" }
    },
    {
      "<leader>z",
      function() Snacks.zen() end,
      desc = "Toggle Zen Mode"
    },
    {
      "<leader>Z",
      function() Snacks.zen.zoom() end,
      desc = "Toggle Zoom"
    },
  },
}

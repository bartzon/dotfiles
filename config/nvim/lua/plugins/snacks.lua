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
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then
          vim.notify("No LSP clients attached to buffer", vim.log.levels.WARN)
          return
        end
        
        local supports_definition = false
        for _, client in ipairs(clients) do
          if client.supports_method("textDocument/definition") then
            supports_definition = true
            break
          end
        end
        
        if not supports_definition then
          vim.notify("No LSP client supports textDocument/definition", vim.log.levels.WARN)
          return
        end
        
        local ok, err = pcall(function()
          Snacks.picker.lsp_definitions({
            filter = {
              filter = function(item, self)
                return not (item.file and item.file:match("%.rbi$"))
              end,
            },
          })
        end)
        if not ok then
          vim.notify("Falling back to built-in LSP definition", vim.log.levels.WARN)
          vim.lsp.buf.definition()
        end
      end,
      desc = "LSP Definitions"
    },
    {
      'gr',
      function()
        local clients = vim.lsp.get_clients({ bufnr = 0 })
        if #clients == 0 then
          vim.notify("No LSP clients attached to buffer", vim.log.levels.WARN)
          return
        end
        
        local supports_references = false
        for _, client in ipairs(clients) do
          if client.supports_method("textDocument/references") then
            supports_references = true
            break
          end
        end
        
        if not supports_references then
          vim.notify("No LSP client supports textDocument/references", vim.log.levels.WARN)
          return
        end
        
        local ok, err = pcall(function()
          Snacks.picker.lsp_references({
            filter = {
              filter = function(item, self)
                return not (item.file and item.file:match("%.rbi$"))
              end,
            },
          })
        end)
        if not ok then
          vim.notify("Falling back to built-in LSP references", vim.log.levels.WARN)
          vim.lsp.buf.references()
        end
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

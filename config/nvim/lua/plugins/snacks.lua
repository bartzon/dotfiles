local progress = vim.defaulttable()

vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local value = ev.data.params
        .value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
    if not client or type(value) ~= "table" then
      return
    end
    local p = progress[client.id]

    for i = 1, #p + 1 do
      if i == #p + 1 or p[i].token == ev.data.params.token then
        p[i] = {
          token = ev.data.params.token,
          msg = ("[%3d%%] %s%s"):format(
            value.kind == "end" and 100 or value.percentage or 100,
            value.title or "",
            value.message and (" **%s**"):format(value.message) or ""
          ),
          done = value.kind == "end",
        }
        break
      end
    end

    local msg = {}
    progress[client.id] = vim.tbl_filter(function(v)
      return table.insert(msg, v.msg) or not v.done
    end, p)

    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    vim.notify(table.concat(msg, "\n"), "info", {
      id = "lsp_progress",
      title = client.name,
      opts = function(notif)
        notif.icon = #progress[client.id] == 0 and " "
            or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
      end,
    })
  end,
})

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    gitbrowse = { enabled = true },
    picker = { enabled = true },
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
    { "<leader><leader>", function() Snacks.picker.smart() end,           desc = "Smart Find Files" },
    { "<leader>sw",       function() Snacks.picker.grep_word() end,       desc = "Visual selection or word", mode = { "n", "x" } },
    { "<leader>fb",       function() Snacks.picker.buffers() end,         desc = "Buffers" },
    { "<leader>fs",       function() Snacks.picker.lsp_symbols() end,     desc = "LSP Symbols" },
    { 'gd',               function() Snacks.picker.lsp_definitions() end, desc = "LSP Definitions" },
    { 'gr',               function() Snacks.picker.lsp_references() end,  desc = "LSP References" },

    { "<leader>gb",       function() Snacks.gitbrowse() end,              desc = "Git Browse",               mode = { "n", "v" } },

    { "<leader>z",        function() Snacks.zen() end,                    desc = "Toggle Zen Mode" },
    { "<leader>Z",        function() Snacks.zen.zoom() end,               desc = "Toggle Zoom" },
  },
}

local Plugin = { 'zbirenbaum/copilot.lua' }

Plugin.cmd = 'Copilot'

Plugin.event = "InsertEnter"

Plugin.opts = {
  panel = {
    enabled = true,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<C-space>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom",
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    debounce = 75,
    keymap = {
      accept = "<C-space>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 16.x
  server_opts_overrides = {},
}

function Plugin.config(_, opts)
  require('copilot').setup(opts)
end

return Plugin

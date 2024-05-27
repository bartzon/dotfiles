local Plugin = { 'folke/trouble.nvim' }

-- Plugin.branch = 'dev'

Plugin.dependencies = {
  { "nvim-tree/nvim-web-devicons" },
}

Plugin.opts = {
  position = "bottom",
  mode = "workspace_diagnostics",
}

return Plugin

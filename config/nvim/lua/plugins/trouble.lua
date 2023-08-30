local Plugin = { 'folke/trouble.nvim' }

Plugin.cmd = { 'TroubleToggle', 'Trouble' }

Plugin.opts = {
  position = 'bottom',
  mode = 'workspace_diagnostics',
  auto_open = true,
  auto_close = true,
  use_diagnostic_signs = true,
}

Plugin.keys = {
  {
    "<leader>tt", "<cmd>TroubleToggle<cr>",
  },
  {
    "[q",
    function()
      if require("trouble").is_open() then
        require("trouble").previous({ skip_groups = true, jump = true })
      else
        vim.cmd.cprev()
      end
    end,
    desc = "Previous trouble/quickfix item",
  },
  {
    "]q",
    function()
      if require("trouble").is_open() then
        require("trouble").next({ skip_groups = true, jump = true })
      else
        vim.cmd.cnext()
      end
    end,
    desc = "Next trouble/quickfix item",
  },
}

return Plugin

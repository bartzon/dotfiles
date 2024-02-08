local Plugin = { 'folke/noice.nvim' }

Plugin.event = 'VeryLazy'
Plugin.dependencies = {
  { 'MunifTanjim/nui.nvim' },
  { 'rcarriga/nvim-notify' },
}

function Plugin.config()
  require("noice").setup({
  })
end

return Plugin

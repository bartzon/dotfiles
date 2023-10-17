local Plugin = { 'lukas-reineke/indent-blankline.nvim' }

Plugin.main = 'ibl'

function Plugin.config()
  require('ibl').setup({
  })
end

return Plugin

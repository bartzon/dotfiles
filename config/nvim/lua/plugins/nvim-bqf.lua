local Plugin = { 'kevinhwang91/nvim-bqf' }

function Plugin.config()
  require('bqf').setup({
    preview = {
      border = { '', '─', '', '', '', '─', '', '' },
      winblend = 0,
      win_height = 20,
    }
  })
end

return Plugin

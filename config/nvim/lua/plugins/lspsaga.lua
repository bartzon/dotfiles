local Plugin = { 'nvimdev/lspsaga.nvim' }

Plugin.dependencies = {
  'nvim-treesitter/nvim-treesitter',
  'nvim-tree/nvim-web-devicons',
}

function Plugin.config()
  require('lspsaga').setup({})
end

return Plugin

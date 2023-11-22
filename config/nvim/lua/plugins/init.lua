local Plugins = {
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
  },
  -- { 'tpope/vim-obsession' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-projectionist' },
  {
    'tpope/vim-fugitive',
    dependencies = {
      'tpope/vim-rhubarb',
    }
  },
  { 'nvim-tree/nvim-web-devicons' },
}

return Plugins

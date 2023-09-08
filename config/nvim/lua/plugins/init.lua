local Plugins = {
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
  },
  { 'bartzon/vim-fzf-coauthorship' },
  { 'tpope/vim-obsession' },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-projectionist' },
  {
    'tpope/vim-fugitive',
    dependencies = {
      'tpope/vim-rhubarb',
    }
  },
  { 'tpope/vim-vinegar' },
  { 'nvim-tree/nvim-web-devicons' },
}

return Plugins

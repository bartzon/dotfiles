local Plugins = {
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
  },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-projectionist' },
  { 'tpope/vim-rails' },
  { 'tyru/open-browser.vim' },
  {
    'tpope/vim-fugitive',
    dependencies = { 'tpope/vim-rhubarb' }
  },
  { 'folke/zen-mode.nvim' },
  { 'nvim-tree/nvim-web-devicons' },
  { 'christoomey/vim-tmux-navigator' },
}

return Plugins

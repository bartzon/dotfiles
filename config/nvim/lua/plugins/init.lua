return {
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
  },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
  { 'tpope/vim-commentary' },
  { 'tpope/vim-projectionist' },
  { 'tpope/vim-rails' },
  {
    'folke/zen-mode.nvim',
    keys = {
      { '<leader>zm', ':lua require("zen-mode").toggle()<CR>', desc = 'Toggle zen mode' }
    },
  },
  { 'nvim-tree/nvim-web-devicons' },
  { 'christoomey/vim-tmux-navigator' },
  { 'tpope/vim-rhubarb',             dependencies = { { 'tpope/vim-fugitive' } } },
  { 'sindrets/diffview.nvim' },
}

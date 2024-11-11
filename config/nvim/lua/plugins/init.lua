return {
  -- Theme
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
  },

  -- UI enhancements
  { 'nvim-tree/nvim-web-devicons' },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
  { 'brenoprata10/nvim-highlight-colors' },
  {
    'folke/zen-mode.nvim',
    keys = {
      { '<leader>zm', ':lua require("zen-mode").toggle()<CR>', desc = 'Toggle zen mode' }
    },
  },

  -- Git integration
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb',     dependencies = { 'tpope/vim-fugitive' } },
  { 'sindrets/diffview.nvim' },

  -- Rails
  { 'tpope/vim-projectionist' },
  { 'tpope/vim-rails' },

  -- Local plugins
  {
    'proxy_key',
    dir = '../local-plugins/proxy_key',
    config = function()
      require('local-plugins.proxy_key').setup()
    end,
    event = 'VeryLazy',
  },

  -- Misc
  { 'tpope/vim-commentary' },
}

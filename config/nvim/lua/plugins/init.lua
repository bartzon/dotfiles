return {
  -- Theme
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
  },

  -- UI enhancements
  { 'nvim-tree/nvim-web-devicons' },
  -- { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
  { 'brenoprata10/nvim-highlight-colors' },

  -- Rails
  { 'tpope/vim-projectionist' },
  { 'tpope/vim-rails' },

  -- Local plugins
  -- {
  --   'proxy_key',
  --   dir = '../local-plugins/proxy_key',
  --   config = function()
  --     require('local-plugins.proxy_key').setup()
  --   end,
  --   event = 'VeryLazy',
  -- },

  -- Misc
  { 'tpope/vim-commentary' },
}

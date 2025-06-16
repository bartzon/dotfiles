return {
  -- Theme
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      -- Set all gruvbox options before loading
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_background = 'medium'
      vim.g.gruvbox_material_foreground = 'material'
      vim.g.gruvbox_material_enable_italic = 0
      vim.g.gruvbox_material_disable_italic_comment = 1
      
      -- Enable termguicolors
      vim.o.termguicolors = true
      vim.o.background = 'dark'
      
      -- Load colorscheme
      vim.cmd('colorscheme gruvbox-material')
      
      -- Ensure syntax is on
      vim.cmd('syntax enable')
    end,
  },

  -- UI enhancements
  { 'nvim-tree/nvim-web-devicons' },
  {
    'brenoprata10/nvim-highlight-colors',
    event = 'BufReadPre',
    opts = {
      render = 'background',
      enable_named_colors = true,
      enable_tailwind = false,
    }
  },

  -- Rails
  { 'tpope/vim-projectionist' },
  { 'tpope/vim-rails' },
}

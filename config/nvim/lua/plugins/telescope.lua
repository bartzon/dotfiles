return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'aznhe21/actions-preview.nvim' },
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      config = function()
        require('telescope').load_extension('fzf')
      end
    },
    {
      'nvim-telescope/telescope-fzy-native.nvim',
      config = function()
        require('telescope').load_extension('fzy_native')
      end
    },
  },
  cmd = 'Telescope',
  opts = {
    defaults = {
      file_ignore_patterns = {
        'sorbet/',
        'node_modules/',
      },
    },
  },
}

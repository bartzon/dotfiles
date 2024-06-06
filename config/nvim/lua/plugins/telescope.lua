local Plugin = { 'nvim-telescope/telescope.nvim' }

Plugin.dependencies = {
  { 'nvim-lua/plenary.nvim' },
  { 'aznhe21/actions-preview.nvim' },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },
}

Plugin.cmd = 'Telescope'

Plugin.opts = {
  defaults = {
    wrap_results = true,
    file_ignore_patterns = {
      '**/*.rbi',
      'node_modules/**/*',
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--hidden",
      "--smart-case",
    },
  },
}

function Plugin.config()
  require('telescope').setup {
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
      }
    }
  }
  require('telescope').load_extension('fzf')
  require('actions-preview').setup {}
end

return Plugin

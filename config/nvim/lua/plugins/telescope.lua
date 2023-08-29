local Plugin = { 'nvim-telescope/telescope.nvim' }

Plugin.dependencies = {
  { 'nvim-lua/plenary.nvim' },
  { 'dhruvmanila/browser-bookmarks.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
}

Plugin.cmd = 'Telescope'

Plugin.opts = {
  defaults = {
    file_ignore_patterns = {
      'sorbet'
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
    },
    bookmarks = {
      selected_browser = 'chrome',
    }
  }
}

function Plugin.init()
  require('telescope').load_extension('bookmarks')
  require('telescope').load_extension('fzf')
end

return Plugin

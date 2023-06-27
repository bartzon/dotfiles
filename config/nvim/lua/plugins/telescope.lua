local Plugin = { 'nvim-telescope/telescope.nvim' }

Plugin.dependencies = {
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope-fzy-native.nvim' },
  { 'dhruvmanila/browser-bookmarks.nvim' },
}

Plugin.cmd = 'Telescope'

Plugin.opts = {
  defaults = {
    file_ignore_patterns = {
      "sorbet"
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
end

return Plugin

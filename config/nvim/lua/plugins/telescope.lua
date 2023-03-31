local Plugin = {'nvim-telescope/telescope.nvim'}

Plugin.dependencies = {
  {'nvim-lua/plenary.nvim'},
  {'nvim-telescope/telescope-fzy-native.nvim'},
  {'dhruvmanila/browser-bookmarks.nvim'},
}

Plugin.cmd = 'Telescope'

Plugin.opts = {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
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

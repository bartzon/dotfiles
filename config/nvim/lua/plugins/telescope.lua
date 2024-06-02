local Plugin = { 'nvim-telescope/telescope.nvim' }

Plugin.dependencies = {
  { 'nvim-lua/plenary.nvim' },
  { 'aznhe21/actions-preview.nvim' },
}

Plugin.cmd = 'Telescope'

Plugin.opts = {
  defaults = {
    find_command = { "fd", "-t=f", "-a" },
    path_display = { "truncate" },
    wrap_results = true,
    file_ignore_patterns = {
      'sorbet'
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
  require('telescope').setup {}
  require('actions-preview').setup {}
end

return Plugin

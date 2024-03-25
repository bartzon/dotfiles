local Plugin = { 'nvim-telescope/telescope.nvim' }

Plugin.dependencies = {
  { 'nvim-lua/plenary.nvim' },
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

return Plugin

local function window()
  return vim.api.nvim_win_get_number(0)
end

return {
  'nvim-lualine/lualine.nvim',
  opts = {
    options = {
      always_divide_middle = true,
      icons_enabled = true,
      theme = 'gruvbox-material',
      component_separators = { " ", " " },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = {
        { window },
        { "mode" },
      },
      lualine_b = {
        {
          'filename',
          file_status = true,
          path = 1,
          on_click = function() vim.cmd('let @+ = expand("%")') end,
        },
        {
          "diagnostics",
          sources = { "nvim_lsp" }
        },
      },
      lualine_x = {
        { "searchcount" },
      },
      lualine_y = {
        { "filetype" },
      },
      lualine_z = {
        { 'location' },
      }
    },
    extensions = {
      'trouble',
      'fzf',
      'lazy',
    },
  },
}

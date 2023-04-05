local Plugin = {'nvim-lualine/lualine.nvim'}

Plugin.dependencies = {{'arkav/lualine-lsp-progress'}}

local function window()
  return vim.api.nvim_win_get_number(0)
end

function Plugin.config()
  require('lualine').setup({
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
        }
      },
      lualine_c = {
        {
          "diagnostics",
          sources = { "nvim_lsp", "nvim_diagnostic" }
        },
        { 'lsp_progress' },
      },
      lualine_x = {
        { "searchcount" },
      },
      lualine_y = {
        { "filetype" },
      },
      lualine_z = {
        { 'location' },
        { 'progress' },
      }
    },
    extensions = {
      'trouble',
      'fzf',
      'lazy',
    },
  })
end

return Plugin

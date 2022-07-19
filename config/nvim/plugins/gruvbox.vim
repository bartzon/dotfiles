Plug 'ellisonleao/gruvbox.nvim'

lua<<EOF
function setup_gruvbox()
  require("gruvbox").setup({
    undercurl = true,
    underline = true,
    bold = true,
    italic = true,
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "", -- can be "hard", "soft" or empty string
    overrides = {},
  })
  vim.cmd("colorscheme gruvbox")
end
EOF

augroup GruvboxOverride
  autocmd User PlugLoaded ++nested lua setup_gruvbox()
augroup end

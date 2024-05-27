local Plugin = { 'kristijanhusak/vim-dadbod-ui' }

Plugin.dependencies = {
  { 'tpope/vim-dadbod',                     lazy = true },
  { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
}

Plugin.cmd = {
  'DBUI',
  'DBUIToggle',
  'DBUIAddConnection',
  'DBUIFindBuffer',
}

function Plugin.init()
  -- Your DBUI configuration
  vim.g.db_ui_use_nerd_fonts = 1
end

return Plugin

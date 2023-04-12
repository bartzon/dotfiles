local Plugin = { 'andymass/vim-matchup' }

function Plugin.config()
  vim.g.matchup_matchparen_offscreen = { method = "popup" }
end

return Plugin

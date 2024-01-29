local Plugin = { 'rmagatti/auto-session' }

function Plugin.config()
  require('auto-session').setup({
    auto_session_use_git_branch = true
  })
end

return Plugin

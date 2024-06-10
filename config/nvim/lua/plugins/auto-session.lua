return {
  'rmagatti/auto-session',
  options = {
    auto_session_use_git_branch = true,
  },
  config = function()
    require('auto-session').setup {}
  end
}

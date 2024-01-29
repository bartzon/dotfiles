local Plugin = { 'zbirenbaum/copilot.lua' }

Plugin.event = 'InsertEnter'
Plugin.cmd = 'Copilot'

function Plugin.config()
  require('copilot').setup {}
end

return Plugin

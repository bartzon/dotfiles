local Plugin = {'tyru/open-browser.vim'}

function Plugin.init()
  local bind = vim.keymap.set

  bind('n', 'goog', '<Plug>(openbrowser-smart-search)')
  bind('v', 'goog', '<Plug>(openbrowser-smart-search)')
end

return Plugin

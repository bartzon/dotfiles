local Plugin = { 'vim-test/vim-test' }

function Plugin.init()
  vim.g['test#strategy'] = "vimux"
end

return Plugin

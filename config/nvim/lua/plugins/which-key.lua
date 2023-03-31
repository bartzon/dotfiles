local Plugin = {'folke/which-key.nvim'}

function Plugin.config()
  vim.o.timeout = true
  vim.o.timeoutlen = 500
  require("which-key").setup({})
end

return Plugin

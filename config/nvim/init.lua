-- Try to load "env" file
local ok, env = pcall(require, 'user.env')

if not ok then
  local msg = 'lua/user/env.lua not found. You should probably create it'
  vim.notify(msg, vim.log.levels.ERROR)
  return
end

vim.g.mapleader = ' '

require('user.plugins')
require('user.settings')
require('user.commands')
require('user.keymaps')

vim.cmd('colorscheme gruvbox-material')

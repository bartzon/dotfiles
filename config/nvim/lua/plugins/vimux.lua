local Plugin = {'preservim/vimux'}

vim.g.VimuxOrientation = "h"
vim.keymap.set('n', '<leader>vo', ':VimuxOpenRunner<CR>')

return Plugin

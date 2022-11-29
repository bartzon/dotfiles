Plug 'chrisgrieser/nvim-genghis'

lua <<EOF
function genghis_setup()
  local keymap = vim.keymap.set
  local genghis = require("genghis")
  keymap("n", "<leader>yp", genghis.copyFilepath)
  keymap("n", "<leader>yn", genghis.copyFilename)
  keymap("n", "<leader>cx", genghis.chmodx)
  keymap("n", "<leader>rf", genghis.renameFile)
  keymap("n", "<leader>nf", genghis.createNewFile)
  keymap("n", "<leader>yf", genghis.duplicateFile)
  keymap("n", "<leader>df", function () genghis.trashFile{trashLocation = "$HOME/.Trash"} end)
  keymap("x", "<leader>mn", genghis.moveSelectionToNewFile)
end
EOF

augroup LualineSetup
  autocmd User PlugLoaded ++nested lua genghis_setup()
augroup end

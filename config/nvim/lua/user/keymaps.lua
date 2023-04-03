local function close_floating()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "win" then
      vim.api.nvim_win_close(win, false)
    end
  end
end

local bind = vim.keymap.set

for i = 1, 6 do
  local lhs = '<leader>' .. i
  local rhs = i .. '<C-W>w'
  bind('n', lhs, rhs, { desc = "Move to window " .. i })
end

bind('n', '<C-j>', '<C-w>j', { desc = "Move to down pane" })
bind('n', '<C-k>', '<C-w>k', { desc = "Move to up pane" })
bind('n', '<C-h>', '<C-w>h', { desc = "Move to left pane" })
bind('n', '<C-l>', '<C-w>l', { desc = "Move to right pane" })
bind('n', '<leader>=', '<C-w>=', { desc = "Reformat panes" })

bind('v', 'J', ":m '>+1<CR>gv=gv", { desc = "Move line up" })
bind('v', 'K', ":m '<-2<CR>gv=gv", { desc = "Move line down" })

bind('n', '<leader>dt', ":VimuxRunCommand 'dt'<CR>", { desc = "dev test" })
bind('n', '<leader>dr', ":VimuxRunCommand 'dr'<CR>", { desc = "dev style" })
bind('n', '<leader>ds', ":VimuxRunCommand 'ds'<CR>", { desc = "srb typecheck" })
bind('n', '<leader>da', ":VimuxRunCommand 'da'<CR>", { desc = "dev all" })
bind('n', '<leader>tf', ":TestFile<CR>", { desc = "Test File" })
bind('n', '<leader>tn', ":TestNearest<CR>", { desc = "Test Nearest" })

bind('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = "Telescope live grep" })
bind('n', '<leader>ff' , ':Telescope find_files<CR>', { desc = "Telescope find files" })
bind('n', '<leader><leader>' , ':Telescope find_files<CR>', { desc = "Telescope find files" })
bind('n', '<leader>fb' , ':Telescope buffers<CR>', { desc = "Telescope find in buffers" })
bind('n', '<leader>fd' , 'telescope.lsp_document_symbols', { desc = 'LSP Document symbols' })
bind('n', '<leader>fq' , 'telescope.lsp_workspace_symbols', { desc = 'LSP Workspace symbols' })
bind('n', '<leader>fm' , ':Telescope bookmarks<CR>', { desc = 'Fuzzy find bookmarks' })

bind('n', 'gd',  '<cmd>Telescope lsp_definitions<CR>', { desc = "LSP definitions" })
bind('n', 'gD',  'lsp.declaration', { desc = 'LSP declarations' })
bind('n', 'gi',  '<cmd>Telescope lsp_implementation', { desc = 'LSP Implementation' })
bind('n', 'go',  'lsp.type_definition', { desc = 'LSP Type definition' })
bind('n', 'gr',  '<cmd>Telescope lsp_references', { desc = 'LSP References' })
bind('n', 'gs',  'lsp.signature_help', { desc = 'LSP Signature help' })
bind('n', 'gl',  'vim.diagnostic.open_float', { desc = 'Diagnostics Float' })
bind('n', 'gq', '<cmd>LspZeroFormat<cr>', { desc = 'Format using LSP' })

bind('n', 'tn', ':tabnext<CR>', { desc = "Next tab" })
bind('n', 'tp', ':tabprev<CR>', { desc = "Previous tab" })
bind('n', 'tt', ':tabnew<CR>', { desc = "New tab" })
bind('n', 'tc', ':tabclose<CR>', { desc = "Close tab" })


bind('n', '<esc>', function()
  close_floating()
  vim.cmd(":noh")
end, { silent = true, desc = "Remove Search Highlighting, Dismiss Popups" })

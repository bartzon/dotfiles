local bind = vim.keymap.set

for i = 1, 6 do
  local lhs = '<leader>' .. i
  local rhs = i .. '<C-W>w'
  bind('n', lhs, rhs, { desc = "Move to window " .. i })
end

function vim.getVisualSelection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ''
  end
end

bind('n', '<C-j>', '<C-w>j', { desc = "Move to down pane" })
bind('n', '<C-k>', '<C-w>k', { desc = "Move to up pane" })
bind('n', '<C-h>', '<C-w>h', { desc = "Move to left pane" })
bind('n', '<C-l>', '<C-w>l', { desc = "Move to right pane" })
bind('n', '<leader>=', '<C-w>=', { desc = "Reformat panes" })

bind('v', 'J', ":m '>+1<CR>gv=gv", { desc = "Move line up" })
bind('v', 'K', ":m '<-2<CR>gv=gv", { desc = "Move line down" })

bind('n', '<leader>w', ":w<CR>", { desc = "Write file", silent = true })
bind('n', '<leader>pr', ":!dev open pr<CR>", { desc = "Open PR", silent = true })

bind('n', '<leader>dt', ":VimuxRunCommand 'dt'<CR>", { desc = "dev test" })
bind('n', '<leader>dr', ":VimuxRunCommand 'dr'<CR>", { desc = "dev style" })
bind('n', '<leader>ds', ":VimuxRunCommand 'ds'<CR>", { desc = "srb typecheck" })
bind('n', '<leader>da', ":VimuxRunCommand 'da'<CR>", { desc = "dev all" })
bind('n', '<leader>tf', ":TestFile<CR>", { desc = "Test File" })
bind('n', '<leader>tn', ":TestNearest<CR>", { desc = "Test Nearest" })
bind('n', '<leader>ts', ":TestNearest<CR>", { desc = "Test Nearest" })

bind('n', '<leader><leader>', ':Telescope find_files<CR>', { desc = "Telescope find files" })
bind('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = "Telescope live grep" })
bind('n', '<leader>ff', ':Telescope find_files<CR>', { desc = "Telescope find files" })
bind('n', '<leader>fb', ':Telescope buffers<CR>', { desc = "Telescope find in buffers" })
bind('n', '<leader>fd', 'telescope.lsp_document_symbols', { desc = 'LSP Document symbols' })
bind('n', '<leader>fq', 'telescope.lsp_workspace_symbols', { desc = 'LSP Workspace symbols' })
bind('n', '<leader>fm', ':Telescope bookmarks<CR>', { desc = 'Fuzzy find bookmarks' })
bind("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, desc = 'Rename using LSP' })
bind('v', '<leader>fg', function()
  local text = vim.getVisualSelection()
  require('telescope.builtin').live_grep({ default_text = text })
end, { noremap = true, desc = 'Telescope live grep selection' })

bind('n', 'gd', ':Telescope lsp_definitions<CR>', { desc = "LSP definitions" })
bind('n', 'gD', 'lsp.declaration', { desc = 'LSP declarations' })
bind('n', 'gi', '<cmd>Telescope lsp_implementation', { desc = 'LSP Implementation' })
bind('n', 'go', 'lsp.type_definition', { desc = 'LSP Type definition' })
bind('n', 'gr', ':Telescope lsp_references<CR>', { desc = 'LSP References' })
bind('n', 'gs', ':lsp.signature_help', { desc = 'LSP Signature help' })
bind('n', 'gl', 'vim.diagnostic.open_float', { desc = 'Diagnostics Float' })
bind('n', 'gq', ':LspZeroFormat<cr>', { desc = 'Format using LSP' })
bind("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, desc = 'Rename with LSP' })
bind("n", '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, desc = 'Previous diagnostic' })
bind("n", ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, desc = 'Next diagnostic' })

bind('n', 'tn', ':tabnext<CR>', { desc = "Next tab" })
bind('n', 'tp', ':tabprev<CR>', { desc = "Previous tab" })
bind('n', 'tt', ':tabnew<CR>', { desc = "New tab" })
bind('n', 'tc', ':tabclose<CR>', { desc = "Close tab" })

bind('n', '<leader>tt', ':TroubleClose<CR>', { desc = "Close Trouble pane" })

bind('n', 'sw', '<cmd>Telescope grep_string<CR>', { desc = 'Search word under cursor' })

bind('n', '<leader>bc', ':close<CR>', { desc = 'Close buffer' })
bind('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })

bind('n', '<esc>', function()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "win" then
      vim.api.nvim_win_close(win, false)
    end
  end
  vim.cmd(":noh")
end, { silent = true, desc = "Remove Search Highlighting, Dismiss Popups" })

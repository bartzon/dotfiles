local bind = vim.keymap.set

for i = 1, 6 do
  local lhs = '<leader>' .. i
  local rhs = i .. '<C-W>w'
  bind('n', lhs, rhs, { desc = "Move to window " .. i })
end

function vim.getVisualSelection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v') or ""
  vim.fn.setreg('v', {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ''
  end
end

bind('n', '<leader>r', ':so ~/.config/nvim/init.lua<CR>', { desc = "Reload config" })

bind('n', 'goog', '<Plug>(openbrowser-smart-search)', { desc = "Search using Google" })
bind('v', 'goog', '<Plug>(openbrowser-smart-search)', { desc = "Search using Google" })

bind('n', '<leader>vo', ':VimuxOpenRunner<CR>', { desc = "Open Vimux window", silent = true })
bind('n', '<leader>du', ":VimuxRunCommand 'dev up'<CR>", { desc = "Dev up", silent = true })

-- bind('n', '<C-j>', '<C-w>j', { desc = "Move to down pane" })
-- bind('n', '<C-k>', '<C-w>k', { desc = "Move to up pane" })
-- bind('n', '<C-h>', '<C-w>h', { desc = "Move to left pane" })
-- bind('n', '<C-l>', '<C-w>l', { desc = "Move to right pane" })
bind('n', '<leader>=', '<C-w>=', { desc = "Reformat panes" })

bind('v', 'J', ":m '>+1<CR>gv=gv", { desc = "Move line up" })
bind('v', 'K', ":m '<-2<CR>gv=gv", { desc = "Move line down" })

bind('n', '<leader>w', ":w<CR>", { desc = "Write file", silent = true })
bind('n', '<leader>pr', ":!dev open pr<CR>", { desc = "Open PR", silent = true })

bind('n', '<leader>cp', ':let @+=@%<CR>', { desc = 'Copy current file path to clipboard', silent = true })

bind('n', '<leader>dt', ":VimuxRunCommand 'dt'<CR>", { desc = "dev test", silent = true })
bind('n', '<leader>dr', ":VimuxRunCommand 'dr'<CR>", { desc = "dev style", silent = true })
bind('n', '<leader>ds', ":VimuxRunCommand 'ds'<CR>", { desc = "srb typecheck", silent = true })
bind('n', '<leader>da', ":VimuxRunCommand 'da'<CR>", { desc = "dev all", silent = true })
bind('n', '<leader>tf', ":TestFile<CR>", { desc = "Test File", silent = true })
bind('n', '<leader>ts', ":TestNearest<CR>", { desc = "Test Nearest", silent = true })

bind('n', 'gt', ':vsplit | lua vim.lsp.buf.definition()<CR>', {})
bind('n', 'gT', ':tabnew | lua vim.lsp.buf.definition()<CR>', {})

bind('n', '<leader>tp', ':silent !echo % >> .pinned_tests.txt<CR>', { desc = "Pin file to test suite", silent = true })
bind('n', '<leader>tu', ":silent !sed -i '' '\\@%@d' .pinned_tests.txt<CR>",
  { desc = "Unpin file from test suite", silent = true })
bind('n', '<leader>tl', ':silent vspl .pinned_tests.txt<CR>', { desc = "List test suite", silent = true })
bind('n', '<leader>tS', ":VimuxRunCommand 'dev test $(< .pinned_tests.txt | uniq)'<CR>",
  { desc = "Run test suite", silent = true })

bind('n', '<leader><leader>', ':Telescope find_files<CR>', { desc = "Telescope find files" })
bind('n', '<leader>sw', ':Telescope live_grep<CR>', { desc = "Telescope live grep" })
bind('n', '<leader>ff', ':FzfLua files<CR>', { desc = "FzfLua find files" })
bind('n', '<leader>fb', ':Telescope buffers<CR>', { desc = "Telescope find in buffers" })
bind('n', '<leader>fs', ':Telescope lsp_document_symbols<CR>', { desc = "Telescope find in document symbols" })
bind('v', '<leader>sw', function()
  local text = vim.getVisualSelection()
  require('telescope.builtin').live_grep({ default_text = text })
end, { noremap = true, desc = 'Telescope live grep selection' })

bind('n', 'gd', ':Telescope lsp_definitions<CR>', { desc = "LSP definitions" })
bind('n', 'gr', ':Telescope lsp_references<CR>', { desc = 'LSP References' })
bind('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Diagnostics Float' })
bind('n', "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, desc = 'Rename with LSP' })

bind('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, desc = 'Previous diagnostic' })
bind('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, desc = 'Next diagnostic' })
bind('n', 'ca', '<cmd>lua require("actions-preview").code_actions()<CR>', { noremap = true, desc = 'Code actions' })
bind('n', 'K', vim.lsp.buf.hover, { noremap = true, desc = 'Show definition' })

bind('n', 'tn', ':tabnext<CR>', { desc = "Next tab" })
bind('n', 'tp', ':tabprev<CR>', { desc = "Previous tab" })
bind('n', 'tt', ':tabnew<CR>', { desc = "New tab" })
bind('n', 'tc', ':tabclose<CR>', { desc = "Close tab" })

bind('n', '<leader>bc', ':close<CR>', { desc = 'Close buffer', silent = true })
bind('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer', silent = true })

bind("n", "<leader>tt", ':Trouble diagnostics toggle<CR>', { desc = 'Trouble toggle', silent = true })

bind('n', '<esc>', function()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "win" then
      vim.api.nvim_win_close(win, false)
    end
  end
  vim.cmd(":noh")
end, { silent = true, desc = "Remove Search Highlighting, Dismiss Popups" })

bind('n', '<leader>hp', ':Gitsigns preview_hunk_inline<CR>', { desc = 'Preview hunk inline', silent = true })

bind('n', '<leader>zm', ':lua require("zen-mode").toggle()<CR>', { desc = 'Toggle zen mode', silent = true })

bind('n', '<leader>tapi', ':VimuxRunCommand "./bin/tapioca dsl ".bufname("%")<CR>',
  { desc = 'Run tapioca for current file', silent = true })

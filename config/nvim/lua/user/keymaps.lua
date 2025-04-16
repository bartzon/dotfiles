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

bind('n', '<leader>=', '<C-w>=', { desc = "Reformat panes" })

bind('v', 'J', ":m '>+1<CR>gv=gv", { desc = "Move line up" })
bind('v', 'K', ":m '<-2<CR>gv=gv", { desc = "Move line down" })

bind('n', '<leader>w', ":w<CR>", { desc = "Write file", silent = true })
bind('n', '<leader>pr', ":!dev open pr<CR>", { desc = "Open PR", silent = true })

bind('n', '<leader>cp', ':let @+=@%<CR>', { desc = 'Copy current file path to clipboard', silent = true })

bind('n', 'gt', ':vsplit | lua vim.lsp.buf.definition()<CR>', {})
bind('n', 'gT', ':tabnew | lua vim.lsp.buf.definition()<CR>', {})

bind('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Diagnostics Float' })
bind('n', "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { noremap = true, desc = 'Rename with LSP' })
bind('n', "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, desc = 'Code actions' })
bind('v', "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, desc = 'Code actions' })

bind('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, desc = 'Previous diagnostic' })
bind('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, desc = 'Next diagnostic' })
bind('n', 'K', vim.lsp.buf.hover, { noremap = true, desc = 'Show definition' })

bind('n', 'tn', ':tabnext<CR>', { desc = "Next tab" })
bind('n', 'tp', ':tabprev<CR>', { desc = "Previous tab" })
bind('n', 'tt', ':tabnew<CR>', { desc = "New tab" })
bind('n', 'tc', ':tabclose<CR>', { desc = "Close tab" })

bind('n', '<leader>bc', ':close<CR>', { desc = 'Close buffer', silent = true })
bind('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer', silent = true })

bind('n', '<esc>', function()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == "win" then
      vim.api.nvim_win_close(win, false)
    end
  end
  vim.cmd(":noh")
end, { silent = true, desc = "Remove Search Highlighting, Dismiss Popups" })


bind('n', '<leader>tapi', ':VimuxRunCommand "./bin/tapioca dsl ".bufname("%")<CR>',
  { desc = 'Run tapioca for current file', silent = true })

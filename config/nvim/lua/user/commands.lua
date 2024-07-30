local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup('init_cmds', { clear = true })

autocmd('TextYankPost', {
  desc = 'highlight text after is copied',
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual', timeout = 80 })
  end
})

autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'WinEnter' }, {
  desc = 'Turn on relative numbers',
  group = augroup,
  command = 'set rnu'
})

autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'WinLeave' }, {
  desc = 'Turn off relative numbers',
  group = augroup,
  command = 'set nornu'
})

autocmd('VimResized', {
  desc = 'Resize panes after host resize',
  group = augroup,
  command = 'wincmd = '
})

autocmd("FileType", {
  pattern = {
    "checkhealth",
    "fugitive*",
    "git",
    "help",
    "lspinfo",
    "netrw",
    "notify",
    "qf",
    "query",
  },
  callback = function()
    vim.keymap.set("n", "q", vim.cmd.close, { desc = "Close the current buffer", buffer = true })
  end,
})

vim.api.nvim_create_user_command("Gbrowse", function()
  local root = vim.system({ "git", "root" }, { text = true }):wait()
  if root.code ~= 0 then
    print("not a git repository")
    return
  end
  local branch = vim.fn.system("git branch --show-current"):gsub("\n", "")
  local filename = vim.fn.expand("%:p:~:.")
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  if filename == "" then
    print("no file name")
    return
  end
  local result = vim.system({ "gh", "browse", "-b", branch, filename .. ":" .. lnum }, { text = true }):wait()
  if result.code ~= 0 then
    print("Gbrowse error")
  end
end, {})

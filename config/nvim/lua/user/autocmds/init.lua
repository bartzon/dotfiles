local M = {}

function M.setup()
  local autocmd_dir = vim.fn.stdpath('config') .. '/lua/user/autocmds'
  local files = vim.fn.glob(autocmd_dir .. '/*.lua', false, true)

  for _, file in ipairs(files) do
    local filename = vim.fn.fnamemodify(file, ':t')

    if filename ~= 'init.lua' then
      local module_name = vim.fn.fnamemodify(filename, ':r')
      local ok, module = pcall(require, 'user.autocmds.' .. module_name)

      if ok and type(module.setup) == 'function' then
        module.setup()
      end
    end
  end
end

return M

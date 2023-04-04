local Plugin = {'nvim-lualine/lualine.nvim'}

local function window()
  return vim.api.nvim_win_get_number(0)
end

--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ""
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
    end
    return str
  end
end

local lsp_component = {
  -- remove null_ls from lsp clients, adjust formatting
  ---@param message string
  ---@return string
  function(message)
    local buf_clients = vim.lsp.get_active_clients { bufnr = vim.api.nvim_get_current_buf() }
    if buf_clients and next(buf_clients) == nil then
      if type(message) == 'boolean' or #message == 0 then return '' end
      return message
    end

    local buf_client_names = {}

    for _, client in pairs(buf_clients) do
      if client.name ~= 'null-ls' then table.insert(buf_client_names, client.name) end
    end

    buf_client_names = vim.fn.uniq(buf_client_names)

    local number_to_show = 1
    local first_few = vim.list_slice(buf_client_names, 1, number_to_show)
    local extra_count = #(buf_client_names) - number_to_show
    local output = table.concat(first_few, ', ')
    if extra_count > 0 then output = output .. ' +' .. extra_count end
    return output
  end,
  icon = { 'ʪ' },
  color = { gui = 'None' },
  on_click = function() vim.cmd 'LspInfo' end,
}

function Plugin.config()
  require('lualine').setup({
    options = {
      always_divide_middle = true,
      icons_enabled = true,
      theme = 'auto',
      component_separators = { " ", " " },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {},
    },
    sections = {
      lualine_a = {
        { window },
        { "mode", fmt = trunc(80, 1, 0, true) },
      },
      lualine_b = {
        {
          'filename',
          file_status = true,
          path = 1,
          on_click = function() vim.cmd('let @+ = expand("%")') end,
        }
      },
      lualine_c = {
        { "diagnostics", sources = { "nvim_lsp", "nvim_diagnostic" } },
      },
      lualine_x = {
        { "filetype", lsp_component },
      },
      lualine_y = {'progress'},
      lualine_z = {
        {  },
      }
    },
    extensions = {
      'trouble',
      'fzf',
      'lazy',
    }
  })
end

return Plugin

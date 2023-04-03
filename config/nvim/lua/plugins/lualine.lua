local Plugin = {'nvim-lualine/lualine.nvim'}

local function getWords()
  if vim.bo.filetype == "md" or vim.bo.filetype == "txt" or vim.bo.filetype == "markdown" then
    if vim.fn.wordcount().visual_words == 1 then
      return tostring(vim.fn.wordcount().visual_words) .. " word"
    elseif not (vim.fn.wordcount().visual_words == nil) then
      return tostring(vim.fn.wordcount().visual_words) .. " words"
    else
      return tostring(vim.fn.wordcount().words) .. " words"
    end
  else
    return ""
  end
end

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

function Plugin.config()
  require('lualine').setup({
    options = {
      theme = 'auto',
      always_divide_middle = true,
      icons_enabled = true,
      theme = "auto",
      component_separators = { " ", " " },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {},
    },
    sections = {
      lualine_a = {
        { "mode", fmt = trunc(80, 1, nil, true) },
      },
      lualine_b = {
        {
          'filename',
          file_status = true,
          path = 1,
        }
      },
      lualine_c = {
        { "diagnostics", sources = { "nvim_diagnostic" } },
      },
      lualine_x = {
        { "filetype" }
      },
      lualine_y = {'progress'},
      lualine_z = {
        { place, padding = { left = 1, right = 1 } },
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

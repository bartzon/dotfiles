local Plugin = { 'stevearc/conform.nvim' }

Plugin.event = "BufWritePre"
Plugin.cmd = "ConformInfo"

local slow_format_filetypes = {}

Plugin.opts = {
  formatters = {
    custom_eslint = {
      command = './node_modules/.bin/eslint',
      args = { "--fix", "$FILENAME" },
    }
  },
  formatters_by_ft = {
    -- javascript = { 'custom_eslint' },
    -- typescript = { 'custom_eslint' },
    -- typescriptreact = { 'custom_eslint' },
    javascript = { 'eslint_d' },
    typescript = { 'eslint_d' },
    typescriptreact = { 'eslint_d' },
    ruby = { 'rubocop', 'sorbet' },
  },

  format_on_save = function(bufnr)
    if slow_format_filetypes[vim.bo[bufnr].filetype] then
      return
    end
    local function on_format(err)
      if err and err:match("timeout$") then
        slow_format_filetypes[vim.bo[bufnr].filetype] = true
      end
    end

    return { timeout_ms = 200, lsp_fallback = true }, on_format
  end,

  format_after_save = function(bufnr)
    if not slow_format_filetypes[vim.bo[bufnr].filetype] then
      return
    end
    return { lsp_fallback = true }
  end,
}

return Plugin

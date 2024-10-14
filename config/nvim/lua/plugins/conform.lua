return {
  'stevearc/conform.nvim',
  event = 'BufWritePre',
  cmd = 'ConformInfo',
  opts = {
    formatters = {
      custom_eslint = {
        command = './node_modules/.bin/eslint',
        args = { "--fix", "$FILENAME" },
      }
    },
    formatters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      ruby = { 'rubocop', 'sorbet' },
    },
    format_on_save = { timeout_ms = 500 },
  },
}

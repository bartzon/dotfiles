return {
  cmd = { "typescript-language-server", "--stdio" },
  root_markers = { 'tsconfig.json', 'package.json', '.git' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
}
return {
  cmd = { "lua-language-server" },
  root_markers = { '.git', '.luarc.json', '.luarc.jsonc', '.stylua.toml', 'stylua.toml' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}
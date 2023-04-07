local Plugin = {
  'VonHeikemen/lsp-zero.nvim',
  branch = 'v2.x',
  lazy = true,
}

function Plugin.config()
  local lsp = require('lsp-zero').preset({})

  lsp.on_attach(function(_, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
  end)

  lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
  })

  lsp.format_on_save({
    servers = {
      ['lua_ls'] = { 'lua' },
      ['rust_analyzer'] = { 'rust' },
      ['ruby'] = { 'rubocop' },
    }
  })

  lsp.setup()
end

return Plugin

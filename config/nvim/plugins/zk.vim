Plug 'mickael-menu/zk-nvim'

lua << EOF
function zk_setup()
  require("zk").setup({
  picker = "fzf",

  lsp = {
    config = {
      cmd = { "zk", "lsp" },
      name = "zk",
      -- on_attach = ...
      -- etc, see `:h vim.lsp.start_client()`
      },

    -- automatically attach buffers in a zk notebook that match the given filetypes
    auto_attach = {
    enabled = true,
    filetypes = { "markdown" },
    },
  },
})
end
EOF

augroup ZkSetup
  autocmd User PlugLoaded ++nested lua zk_setup()
augroup end

local Plugin = {
  'stevearc/oil.nvim',
}

Plugin.dependencies = {
  { "nvim-tree/nvim-web-devicons" }
}

function Plugin.config()
  require("oil").setup()
end

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

return Plugin

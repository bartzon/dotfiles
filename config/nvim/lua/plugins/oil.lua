local Plugin = {
  'stevearc/oil.nvim',
}

Plugin.dependencies = {
  { "nvim-tree/nvim-web-devicons" }
}

function Plugin.config()
  require("oil").setup({
    skip_confirm_for_simple_edits = true,
    columns = {
      "icon",
      "size",
      "mtime",
    },
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["<C-v>"] = "actions.select_vsplit",
      ["<C-s>"] = "actions.select_split",
      ["<C-t>"] = "actions.select_tab",
      ["<C-p>"] = "actions.preview",
      ["<C-c>"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      ["-"] = "actions.parent",
      ["_"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["gs"] = "actions.change_sort",
      ["gx"] = "actions.open_external",
      ["g."] = "actions.toggle_hidden",
      ["g\\"] = "actions.toggle_trash",
    },
    view_options = {
      show_hidden = true,
    },
  })
end

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

return Plugin

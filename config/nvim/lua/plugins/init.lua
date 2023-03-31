local Plugins = {
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
  },
  {'bartzon/vim-fzf-coauthorship'},
  {'rmagatti/auto-session'},
  {'tpope/vim-commentary'},
  {'tpope/vim-projectionist'},
  {'tpope/vim-vinegar'},
  {
    'vim-test/vim-test',
    init = function()
      vim.g['test#strategy'] = "vimux"
    end
  },
  {
    'folke/which-key.nvim',
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({})
    end
  },
  {'nvim-tree/nvim-web-devicons'},
}

return Plugins

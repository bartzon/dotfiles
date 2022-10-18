Plug 'mfussenegger/nvim-lint'

lua<<EOF
function setup_nvim_lint()
    require('lint').linters_by_ft = {
      markdown = {'vale',},
      ruby = {'rubocop',}
    }
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
      require("lint").try_lint()
      end,
    })
end
EOF


augroup LintSetup
  autocmd User PlugLoaded ++nested lua setup_nvim_lint()
augroup end

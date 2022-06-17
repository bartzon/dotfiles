Plug 'andymass/vim-matchup'

lua <<EOF
function setup_vim_matchup()
  require'nvim-treesitter.configs'.setup {
    matchup = {
      enable = true,              -- mandatory, false will disable the whole extension
      disable = { },  -- optional, list of language that will be disabled
    },
  }
end
EOF

augroup VimMatchupSetup
  autocmd User PlugLoaded ++nested lua setup_vim_matchup()
augroup end

Plug 'akinsho/bufferline.nvim'

lua<<EOF
function bufferline_setup()
  require("bufferline").setup{
    options = {
      right_mouse_command = "vertical sbuffer %d",
      diagnostics = "nvim_lsp",
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        return "("..count..")"
      end,
      show_buffer_icons = true,
      separator_style = "thin",
    }
  }
end
EOF

augroup BufferlineOverride
  autocmd User PlugLoaded ++nested lua bufferline_setup()
augroup end


Plug 'neovim/nvim-lspconfig'
Plug 'tami5/lspsaga.nvim'

lua << EOF
function nvim_lsp_setup()
  local nvim_lsp = require'lspconfig'

  local nnoremap = function (lhs, rhs)
    vim.api.nvim_buf_set_keymap(0, 'n', lhs, rhs, {noremap = true, silent = true})
  end

  local on_attach = function ()
    local mappings = {
      ['K'] = "<cmd>lua require('lspsaga.hover').render_hover_doc()<CR>",
      ['gd'] = "<cmd>lua vim.lsp.buf.definition()<CR>",
      ['gi'] = "<cmd>lua vim.lsp.buf.implementation()<CR>",
      ['gh'] = "<cmd>lua require'lspsaga.provider'.lsp_finder()<CR>",
      ['rn'] = "<cmd>lua vim.lsp.buf.rename()<CR>",
    }

    for lhs, rhs in pairs(mappings) do
      nnoremap(lhs, rhs)
    end
  end

  local configs = require 'lspconfig.configs'
  if not configs.rubocop_lsp then
   configs.rubocop_lsp = {
     default_config = {
       cmd = {'bundle', 'exec', 'rubocop-lsp'};
       filetypes = {'ruby'};
       root_dir = function(fname)
         return nvim_lsp.util.find_git_ancestor(fname)
       end;
       settings = {};
     };
   }
  end

  nvim_lsp.sorbet.setup{
    on_attach = on_attach
  }

  nvim_lsp.rubocop_lsp.setup{
    on_attach = on_attach
  }

  require'lspsaga'.init_lsp_saga{}
end

EOF

augroup NvimLSPSetup
  autocmd User PlugLoaded ++nested lua nvim_lsp_setup()
augroup end

autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})

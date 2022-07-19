Plug 'neovim/nvim-lspconfig'
Plug 'tami5/lspsaga.nvim'
Plug 'folke/lsp-colors.nvim'

lua << EOF
function nvim_lsp_setup()
  local nvim_lsp = require'lspconfig'

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
    cmd = {'bundle', 'exec', 'srb', 'tc', '--lsp'};
  }

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)

  nvim_lsp.rubocop_lsp.setup{}

  nvim_lsp.sumneko_lua.setup{}

  require'lspsaga'.init_lsp_saga{}

  vim.diagnostic.config({virtual_text = false})
end

EOF

augroup NvimLSPSetup
  autocmd User PlugLoaded ++nested lua nvim_lsp_setup()
augroup end

nnoremap <silent> K :Lspsaga hover_doc<CR>
nnoremap <silent> gs :Lspsaga signature_help<CR>
nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh :Lspsaga lsp_finder<CR>
nnoremap <silent>gr :Lspsaga rename<CR>
nnoremap <silent><leader>ca :Lspsaga code_action<CR>
vnoremap <silent><leader>ca :<C-U>Lspsaga range_code_action<CR>
nnoremap <silent> [d :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]d :Lspsaga diagnostic_jump_prev<CR>ig

Plug 'neovim/nvim-lspconfig'
Plug 'tami5/lspsaga.nvim'
Plug 'folke/lsp-colors.nvim'
Plug 'folke/trouble.nvim'

lua << EOF
function nvim_lsp_setup()
  local nvim_lsp = require'lspconfig'

  local configs = require 'lspconfig.configs'
  if not configs.ruby_lsp then
   configs.ruby_lsp = {
     default_config = {
       cmd = {'bundle', 'exec', 'ruby-lsp'};
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

  nvim_lsp.ruby_lsp.setup{}

  require'lspsaga'.init_lsp_saga{}

  require("trouble").setup {
    position = "bottom", -- position of the list can be: bottom, top, left, right
    height = 10, -- height of the trouble list when position is top or bottom
    width = 50, -- width of the list when position is left or right
    mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
  }

  vim.lsp.handlers['textDocument/signatureHelp']  = vim.lsp.with(vim.lsp.handlers['signature_help'], {
     border = 'single',
     close_events = { "CursorMoved", "BufHidden" },
  })
  vim.keymap.set('i', '<c-s>', vim.lsp.buf.signature_help)
end
EOF

augroup NvimLSPSetup
  autocmd User PlugLoaded ++nested lua nvim_lsp_setup()
augroup end

nnoremap <silent> K :Lspsaga hover_doc<CR>
nnoremap <silent> gs :Lspsaga signature_help<CR>
nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gh :Lspsaga lsp_finder<CR>
nnoremap <silent> gr :Lspsaga rename<CR>
nnoremap <silent> ca :Lspsaga code_action<CR>
nnoremap <silent> [d :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> ]d :Lspsaga diagnostic_jump_prev<CR>ig

nnoremap <leader>tt :TroubleToggle<CR>

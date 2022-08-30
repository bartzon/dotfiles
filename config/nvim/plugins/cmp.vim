Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'

Plug 'quangnguyen30192/cmp-nvim-ultisnips'

set completeopt=menu,menuone,noselect

lua<<EOF
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

function nvim_cmp_setup()
  local cmp = require'cmp'

  local lspkindicons = {
    Text = "",
    Method = "",
    Function = "",
    Constructor = "",
    Field = "",
    Variable = "",
    Class = "ﴯ",
    Interface = "",
    Module = "",
    Property = "ﰠ",
    Unit = "",
    Value = "",
    Enum = "",
    Keyword = "",
    Snippet = "",
    Color = "",
    File = "",
    Reference = "",
    Folder = "",
    EnumMember = "",
    Constant = "",
    Struct = "",
    Event = "",
    Operator = "",
    TypeParameter = "",
  }

local cmp_ultisnips_mappings = require("cmp_nvim_ultisnips.mappings")

  cmp.setup({
    completion = {
      autocomplete = false, -- disable auto-completion.
    },
    snippet = {
      expand = function(args)
        vim.fn["UltiSnips#Anon"](args.body)
      end,
    },
    mapping = {
      ['<CR>'] = cmp.mapping.confirm({ select = false }),

      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
          cmp_ultisnips_mappings.expand_or_jump_forwards(fallback)
        elseif has_words_before() then
           cmp.complete()
        else
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item()
        else
          cmp_ultisnips_mappings.jump_backwards(fallback)
        end
      end, { "i", "s" }),


    },
    formatting = {
      format = function(entry, vim_item)
        vim_item.kind = string.format("%s %s", lspkindicons[vim_item.kind], vim_item.kind)
        vim_item.menu = ({
            copilot = "[Cop]",
            nvim_lsp = "[LSP]",
            ultisnips = "[Snip]",
            buffer = "[Buf]",
            path = "[Pat]"
         })[entry.source.name]
        return vim_item
    end,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'ultisnips' },
      { name = 'copilot' },
      { name = 'path' },
      { name = "buffer" },
      { name = "nvim_lua" },
      { name = "treesitter" },
      { name = "spell" },
      { name = "calc" },
      { name = "emoji" },
      { name = 'nvim_lsp_signature_help' },
    })
    }
  )

  cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' }
      }
  })

  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

  require('lspconfig')['sorbet'].setup {
    capabilities = capabilities
  }

  require('lspconfig')['sumneko_lua'].setup {
    capabilities = capabilities
  }
end
EOF


augroup NvimCmpSetup
  autocmd User PlugLoaded ++nested lua nvim_cmp_setup()
augroup end
autocmd BufWritePost *.snippets :CmpUltisnipsReloadSnippets


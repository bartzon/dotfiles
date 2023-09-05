-- Autocompletion
local Plugin = { 'hrsh7th/nvim-cmp' }
local user = { autocomplete = true }

local lsp_symbols = {
  Text          = "   (Text) ",
  Method        = "   (Method)",
  Function      = "   (Function)",
  Constructor   = "   (Constructor)",
  Field         = " ﴲ  (Field)",
  Variable      = "   (Variable)",
  Class         = "   (Class)",
  Interface     = "   (Interface)",
  Module        = "   (Module)",
  Property      = " 襁 (Property)",
  Unit          = "   (Unit)",
  Value         = "   (Value)",
  Enum          = " 練 (Enum)",
  Keyword       = "   (Keyword)",
  Snippet       = "   (Snippet)",
  Color         = "   (Color)",
  File          = "   (File)",
  Reference     = "   (Reference)",
  Folder        = "   (Folder)",
  EnumMember    = "   (EnumMember)",
  Constant      = "   (Constant)",
  Struct        = "   (Struct)",
  Event         = "   (Event)",
  Operator      = "   (Operator)",
  TypeParameter = "   (TypeParameter)"
}

Plugin.dependencies = {
  -- Sources
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-nvim-lua' },

  -- Snippets
  { 'L3MON4D3/LuaSnip' },
}

Plugin.event = 'InsertEnter'

function Plugin.config()
  require('lsp-zero.cmp').extend()

  user.augroup = vim.api.nvim_create_augroup('compe_cmds', { clear = true })
  vim.api.nvim_create_user_command('UserCmpEnable', user.enable_cmd, {})

  local cmp = require('cmp')
  local luasnip = require('luasnip')

  local select_opts = { behavior = cmp.SelectBehavior.Select }
  local cmp_enable = cmp.get_config().enabled

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "nvim_lsp" },
      { name = "nvim_lsp_document_symbol" },
      { name = "dictionary" },
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline(":", {
    completion = {
      autocomplete = { "InsertEnter" },
    },
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "cmdline" },
      {
        name = "path",
        options = {
          trailing_slash = true,
          label_trailing_slash = true
        }
      },
      { name = "dictionary" },
      { name = "buffer" },
    }),
  })

  user.config = {
    enabled = function()
      if user.autocomplete then
        return cmp_enable()
      end

      return false
    end,
    completion = {
      completeopt = 'menu,menuone',
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = {
      { name = 'path' },
      { name = 'nvim_lsp', keyword_length = 3 },
      { name = 'buffer',   keyword_length = 3 },
      { name = 'luasnip',  keyword_length = 2 },
    },
    window = {
      documentation = {
        max_height = 15,
        max_width = 50,
        zindex = 50,
      }
    },
    formatting = {
      fields = { 'menu', 'abbr', 'kind' },
      format = function(entry, item)
        item.kind = lsp_symbols[item.kind] .. " " .. item.kind
        -- set a name for each source
        item.menu = ({
          spell = "[Spell]",
          buffer = "[Buffer]",
          calc = "[Calc]",
          emoji = "[Emoji]",
          nvim_lsp = "[LSP]",
          path = "[Path]",
          look = "[Look]",
          treesitter = "[treesitter]",
          luasnip = "[LuaSnip]",
          nvim_lua = "[Lua]",
          latex_symbols = "[Latex]",
          cmp_tabnine = "[Tab9]"
        })[entry.source.name]
        return item
      end
    },
    mapping = {
      ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
      ['<Down>'] = cmp.mapping.select_next_item(select_opts),
      ['<M-k>'] = cmp.mapping.select_prev_item(select_opts),
      ['<M-j>'] = cmp.mapping.select_next_item(select_opts),
      ['<C-d>'] = cmp.mapping.scroll_docs(5),
      ['<C-u>'] = cmp.mapping.scroll_docs(-5),
      ['<M-u>'] = cmp.mapping(function()
        if cmp.visible() then
          cmp.abort()
          user.set_autocomplete(false)
        else
          cmp.complete()
          user.set_autocomplete(true)
        end
      end),
      ['<Tab>'] = cmp.mapping(function(fallback)
        user.set_autocomplete(true)

        if cmp.visible() then
          cmp.confirm({ select = true })
        elseif luasnip.jumpable(1) then
          luasnip.jump(1)
        elseif user.check_back_space() then
          fallback()
        else
          cmp.complete()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function() luasnip.jump(-1) end, { 'i', 's' }),
    }
  }

  cmp.setup(user.config)
end

function user.set_autocomplete(new_value)
  local old_value = user.autocomplete

  if new_value == old_value then
    return
  end

  if new_value == false then
    -- restore autocomplete in the next word
    vim.api.nvim_buf_set_keymap(
      0,
      'i',
      '<Space>',
      '<cmd>UserCmpEnable<CR><Space>',
      { noremap = true }
    )

    -- restore when leaving insert mode
    vim.api.nvim_create_autocmd('InsertLeave', {
      group = user.augroup,
      command = 'UserCmpEnable',
      once = true,
    })
  end

  user.autocomplete = new_value
end

function user.check_back_space()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

function user.enable_cmd()
  if user.autocomplete then
    return
  end

  pcall(vim.api.nvim_buf_del_keymap, 0, 'i', '<Space>')
  user.set_autocomplete(true)
end

return Plugin

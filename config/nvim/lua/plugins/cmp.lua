local Plugin = { 'hrsh7th/nvim-cmp' }
local user = { autocomplete = true }

Plugin.dependencies = {
  { 'L3MON4D3/LuaSnip' },
  { 'hrsh7th/cmp-calc' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-nvim-lua' },
  { 'hrsh7th/cmp-path' },
  { 'onsails/lspkind.nvim' },
  { 'saadparwaiz1/cmp_luasnip' },
  { 'kristijanhusak/vim-dadbod-completion' },
}

Plugin.event = 'InsertEnter'

function Plugin.config()
  user.augroup = vim.api.nvim_create_augroup('compe_cmds', { clear = true })
  vim.api.nvim_create_user_command('UserCmpEnable', user.enable_cmd, {})

  local cmp = require('cmp')
  local luasnip = require('luasnip')
  local lspkind = require('lspkind')

  local select_opts = { behavior = cmp.SelectBehavior.Select }
  local cmp_enable = cmp.get_config().enabled

  user.config = {
    enabled = function()
      if user.autocomplete then
        return cmp_enable()
      end

      return false
    end,
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'buffer' },
      { name = 'luasnip' },
      { name = 'nvim_lua' },
      { name = 'path' },
      { name = 'calc' },
      { name = 'vim-dadbod-completion' },
    },
    formatting = {
      format = lspkind.cmp_format(),
    },
    mapping = {
      ['<Tab>'] = cmp.mapping(function(fallback)
        user.set_autocomplete(true)

        if cmp.visible() then
          cmp.select_next_item(select_opts)
        elseif luasnip.jumpable(1) then
          luasnip.jump(1)
        elseif user.check_back_space() then
          fallback()
        else
          cmp.complete()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping.select_prev_item(select_opts),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }
  }

  cmp.setup(user.config)

  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sql", "mysql", "plsql" },
    callback = function()
      cmp.setup.buffer {
        sources = {
          { name = 'vim-dadbod-completion' }
        }
      }
    end,
  })
end

function user.set_autocomplete(new_value)
  local old_value = user.autocomplete

  if new_value == old_value then
    return
  end

  if new_value == false then
    -- restore autocomplete in the next word
    vim.api.nvim_buf_set_keymap(0, 'i', '<Space>', '<cmd>UserCmpEnable<CR><Space>', { noremap = true })

    -- restore when leaving insert mode
    vim.api.nvim_create_autocmd('InsertLeave', { group = user.augroup, command = 'UserCmpEnable', once = true, })
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

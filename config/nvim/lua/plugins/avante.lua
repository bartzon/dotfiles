return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = false,
  version = '*',
  build = 'make',
  opts = {
    provider = 'shopify-ai',
    vendors = {
      ['shopify-ai'] = {
        endpoint = 'https://proxy.shopify.ai/v3/v1',
        model = 'anthropic:claude-3-5-sonnet',
        api_key_name = 'cmd:openai_key cat',
      },
    },
  },
  config = function(_, opts)
    local avante = require('avante')
    local openai_provider = require('avante.providers.openai')

    opts = vim.tbl_deep_extend('force', {
      vendors = {
        ['shopify-ai'] = {
          parse_curl_args = openai_provider.parse_curl_args,
          parse_response_data = openai_provider.parse_response,
        },
      },
    }, opts or {})

    avante.setup(opts)
  end,
}

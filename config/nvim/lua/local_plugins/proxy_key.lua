local M = {}
local ProxyKey = {}

function ProxyKey:check()
  local check_key = vim.system({ "openai_key", "check" }):wait()
  return check_key["code"] == 0
end

function ProxyKey:refresh()
  vim.system({ "openai_key", "update" }, {
    on_exit = function(_, return_val)
      if return_val == 0 then
        vim.notify("OpenAI proxy-key refreshed", vim.log.levels.INFO)
        ProxyKey:get()
      else
        vim.notify("OpenAI proxy-key refresh failed", vim.log.levels.ERROR)
      end
    end,
  })
end

function ProxyKey:refreshSync()
  vim.system({ "openai_key", "update" })
  return ProxyKey:get()
end

function ProxyKey:get()
  local key = vim.system({ "openai_key", "cat" }):wait()
  vim.g.shopify_proxy_key = key["stdout"]
  return key["stdout"]
end

function ProxyKey:safeGet()
  if not vim.g.shopify_proxy_key and not ProxyKey:check() then
    return ProxyKey:refreshSync()
  end
  return vim.g.shopify_proxy_key
end

M.setup = function()
  local proxy_key = ProxyKey
  if not proxy_key:check() then
    proxy_key:refresh()
  end
  vim.g.shopify_proxy_key = proxy_key:get()
end

M.get_proxy_key = ProxyKey.safeGet

return M

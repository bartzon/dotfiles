local Plugin = { 'iamcco/markdown-preview.nvim' }

Plugin.cmd = { ' MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' }

Plugin.ft = 'markdown'

function Plugin.build()
  vim.fn["mkdp#util#install"]()
end

return Plugin

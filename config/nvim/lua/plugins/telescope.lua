return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
    { 'aznhe21/actions-preview.nvim' },
  },
  cmd = 'Telescope',
  opts = {
    defaults = {
      file_ignore_patterns = {
        'sorbet/',
        '**/*.rbi',
        'node_modules/',
      },
    },
  },
  config = function()
    require('actions-preview').setup({
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.8,
          height = 0.9,
          prompt_position = "top",
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines)
            return max_lines - 15
          end,
        },
      },
    }
    )
  end,
  keys = {
    { '<leader>sw', ':Telescope live_grep<CR>',            desc = "Telescope live grep" },
    { '<leader>ff', ':FzfLua files<CR>',                   desc = "FzfLua find files" },
    { '<leader>fb', ':Telescope buffers<CR>',              desc = "Telescope find in buffers" },
    { '<leader>fs', ':Telescope lsp_document_symbols<CR>', desc = "Telescope find in document symbols" },
    {
      '<leader>sw',
      function()
        local text = vim.getVisualSelection()
        require('telescope.builtin').live_grep({ default_text = text })
      end,
      desc = 'Telescope live grep selection',
      mode = 'v'
    },
    { 'gd', ':Telescope lsp_definitions<CR>', desc = "LSP definitions" },
    { 'gr', ':Telescope lsp_references<CR>',  desc = 'LSP References' },
  },
}

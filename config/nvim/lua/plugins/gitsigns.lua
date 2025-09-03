return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  keys = {
    {
      'g]',
      function()
        require('gitsigns').next_hunk()
      end,
      desc = 'Next git change',
    },
    {
      'g[',
      function()
        require('gitsigns').prev_hunk()
      end,
      desc = 'Previous git change',
    },
    {
      '<leader>hs',
      function()
        require('gitsigns').stage_hunk()
      end,
      desc = 'Stage hunk',
    },
    {
      '<leader>hr',
      function()
        require('gitsigns').reset_hunk()
      end,
      desc = 'Reset hunk',
    },
    {
      '<leader>hs',
      function()
        require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end,
      mode = 'v',
      desc = 'Stage selected hunk',
    },
    {
      '<leader>hr',
      function()
        require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end,
      mode = 'v',
      desc = 'Reset selected hunk',
    },
    {
      '<leader>hS',
      function()
        require('gitsigns').stage_buffer()
      end,
      desc = 'Stage buffer',
    },
    {
      '<leader>hu',
      function()
        require('gitsigns').undo_stage_hunk()
      end,
      desc = 'Undo stage hunk',
    },
    {
      '<leader>hR',
      function()
        require('gitsigns').reset_buffer()
      end,
      desc = 'Reset buffer',
    },
    {
      '<leader>hp',
      function()
        require('gitsigns').preview_hunk()
      end,
      desc = 'Preview hunk',
    },
    {
      '<leader>hb',
      function()
        require('gitsigns').blame_line({ full = true })
      end,
      desc = 'Blame line',
    },
    {
      '<leader>tb',
      function()
        require('gitsigns').toggle_current_line_blame()
      end,
      desc = 'Toggle blame',
    },
    {
      '<leader>hd',
      function()
        require('gitsigns').diffthis()
      end,
      desc = 'Diff this',
    },
    {
      '<leader>hD',
      function()
        require('gitsigns').diffthis('~')
      end,
      desc = 'Diff this ~',
    },
    {
      '<leader>td',
      function()
        require('gitsigns').toggle_deleted()
      end,
      desc = 'Toggle deleted',
    },
  },
  opts = {
    signs = {
      add = { text = '│' },
      change = { text = '│' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
  },
}

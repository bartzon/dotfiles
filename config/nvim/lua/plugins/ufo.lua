return {
  'kevinhwang91/nvim-ufo',
  dependencies = {
    { 'kevinhwang91/promise-async' }
  },
  event = "BufEnter",
  config = function()
    vim.o.foldcolumn = '1' -- '0' is not bad
    vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    vim.o.foldenable = false

    vim.opt.statuscolumn =
        [[%{(foldlevel(v:lnum) && foldlevel(v:lnum) > foldlevel(v:lnum - 1)) ? (foldclosed(v:lnum) == -1 ? '⌄' : '›') : ' '}]] -- Folds
        .. ' ' -- Spacer
        .. '%=%{v:virtnum < 1 ? (v:relnum ? v:relnum : v:lnum) : " "}' -- Line number
        .. '%s' -- Signs

    require('ufo').setup({
      provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
      end
    })
  end,
}

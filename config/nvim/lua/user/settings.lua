local o = vim.opt
local g = vim.g

o.wrap = false
o.expandtab = true
o.smartcase = true
o.ignorecase = true

o.shiftwidth = 2
o.softtabstop = 2
o.tabstop = 2

o.relativenumber = true
o.number = true
o.showmode = false

o.termguicolors = true

o.scrolloff = 5
o.sidescrolloff = 5

o.splitbelow = true
o.splitright = true

o.cmdheight = 0
o.laststatus = 3
o.numberwidth = 5

o.list = true

o.undofile = true
o.backup = false
o.swapfile = false
o.autoread = true

o.equalalways = true

o.pumblend = 15
o.winblend = 15
o.updatetime = 100

o.cursorline = true
o.cursorlineopt = 'number'

o.showmatch = true

o.smartindent = true

o.listchars = 'tab:␉·,trail:␠,nbsp:⎵'

o.mousescroll = 'ver:1,hor:0'

o.signcolumn = 'yes'

o.completeopt = 'menu'

o.background = 'dark'
g.gruvbox_material_better_performance = 1
vim.cmd('colorscheme gruvbox-material')

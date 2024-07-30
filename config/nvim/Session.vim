let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/code/dotfiles/config/nvim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +7 ~/code/dotfiles/config/nvim/lua/plugins/auto-session.lua
badd +21 ~/code/dotfiles/config/nvim/lua/plugins/cmp.lua
badd +1 ~/code/dotfiles/config/nvim/lua/plugins/fzf-lua.lua
badd +11 ~/code/dotfiles/config/nvim/lua/plugins/init.lua
badd +70 ~/code/dotfiles/config/nvim/lua/plugins/lsp_config.lua
badd +7 ~/code/dotfiles/config/nvim/lua/plugins/markdown-preview.lua
badd +3 ~/code/dotfiles/config/nvim/lua/plugins/mini_splitjoin.lua
badd +10 ~/code/dotfiles/config/nvim/lua/plugins/nvim-lint.lua
badd +4 ~/code/dotfiles/config/nvim/lua/plugins/oil.lua
badd +2 ~/code/dotfiles/config/nvim/lua/plugins/splitjoin.lua
badd +9 ~/code/dotfiles/config/nvim/lua/plugins/telescope.lua
badd +89 ~/code/dotfiles/config/nvim/lua/plugins/treesitter.lua
badd +11 ~/code/dotfiles/config/nvim/lua/plugins/trouble.lua
badd +5 ~/code/dotfiles/config/nvim/lua/plugins/copilot.lua
badd +11 ~/code/dotfiles/config/nvim/lua/plugins/conform.lua
badd +13 ~/code/dotfiles/config/nvim/lua/plugins/dadbod-ui.lua
badd +7 ~/code/dotfiles/config/nvim/lua/plugins/lualine.lua
badd +6 ~/code/dotfiles/config/nvim/lua/plugins/vim-test.lua
badd +9 ~/code/dotfiles/config/nvim/lua/plugins/vimux.lua
badd +0 ~/code/dotfiles/config/nvim/lua/user/keymaps.lua
badd +5 ~/code/dotfiles/config/nvim/lua/plugins/open-browser.lua
argglobal
%argdel
edit ~/code/dotfiles/config/nvim/lua/plugins/vimux.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 18 + 19) / 39)
exe 'vert 1resize ' . ((&columns * 91 + 92) / 184)
exe '2resize ' . ((&lines * 19 + 19) / 39)
exe 'vert 2resize ' . ((&columns * 91 + 92) / 184)
exe 'vert 3resize ' . ((&columns * 92 + 92) / 184)
argglobal
balt ~/code/dotfiles/config/nvim/lua/plugins/init.lua
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 9 - ((8 * winheight(0) + 9) / 18)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 9
normal! 03|
wincmd w
argglobal
if bufexists(fnamemodify("~/code/dotfiles/config/nvim/lua/plugins/open-browser.lua", ":p")) | buffer ~/code/dotfiles/config/nvim/lua/plugins/open-browser.lua | else | edit ~/code/dotfiles/config/nvim/lua/plugins/open-browser.lua | endif
if &buftype ==# 'terminal'
  silent file ~/code/dotfiles/config/nvim/lua/plugins/open-browser.lua
endif
balt ~/code/dotfiles/config/nvim/lua/plugins/init.lua
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 5 - ((4 * winheight(0) + 9) / 19)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 5
normal! 049|
wincmd w
argglobal
if bufexists(fnamemodify("~/code/dotfiles/config/nvim/lua/user/keymaps.lua", ":p")) | buffer ~/code/dotfiles/config/nvim/lua/user/keymaps.lua | else | edit ~/code/dotfiles/config/nvim/lua/user/keymaps.lua | endif
if &buftype ==# 'terminal'
  silent file ~/code/dotfiles/config/nvim/lua/user/keymaps.lua
endif
balt ~/code/dotfiles/config/nvim/lua/plugins/vimux.lua
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 24 - ((16 * winheight(0) + 19) / 38)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 24
normal! 0
wincmd w
3wincmd w
exe '1resize ' . ((&lines * 18 + 19) / 39)
exe 'vert 1resize ' . ((&columns * 91 + 92) / 184)
exe '2resize ' . ((&lines * 19 + 19) / 39)
exe 'vert 2resize ' . ((&columns * 91 + 92) / 184)
exe 'vert 3resize ' . ((&columns * 92 + 92) / 184)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :

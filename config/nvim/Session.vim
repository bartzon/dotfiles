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
badd +27 ~/code/dotfiles/linux/install.sh
badd +21 ~/code/dotfiles/zsh/config
badd +2 ~/code/dotfiles/zsh/opts
badd +9 ~/code/dotfiles/zsh/aliases
badd +17 lua/plugins/init.lua
badd +1 lua/plugins
badd +2 lua/plugins/lualine.lua
badd +14 lua/plugins/nvim-ufo.lua
badd +80 lua/plugins/treesitter.lua
argglobal
%argdel
edit lua/plugins/lualine.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
2wincmd h
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
exe 'vert 1resize ' . ((&columns * 77 + 116) / 232)
exe 'vert 2resize ' . ((&columns * 76 + 116) / 232)
exe 'vert 3resize ' . ((&columns * 77 + 116) / 232)
argglobal
balt lua/plugins
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
let s:l = 2 - ((1 * winheight(0) + 32) / 64)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 2
normal! 0
lcd ~/code/dotfiles/config/nvim
wincmd w
argglobal
if bufexists(fnamemodify("~/code/dotfiles/config/nvim/lua/plugins/nvim-ufo.lua", ":p")) | buffer ~/code/dotfiles/config/nvim/lua/plugins/nvim-ufo.lua | else | edit ~/code/dotfiles/config/nvim/lua/plugins/nvim-ufo.lua | endif
if &buftype ==# 'terminal'
  silent file ~/code/dotfiles/config/nvim/lua/plugins/nvim-ufo.lua
endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 14 - ((13 * winheight(0) + 32) / 64)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 14
normal! 0
lcd ~/code/dotfiles/config/nvim
wincmd w
argglobal
if bufexists(fnamemodify("~/code/dotfiles/config/nvim/lua/plugins/treesitter.lua", ":p")) | buffer ~/code/dotfiles/config/nvim/lua/plugins/treesitter.lua | else | edit ~/code/dotfiles/config/nvim/lua/plugins/treesitter.lua | endif
if &buftype ==# 'terminal'
  silent file ~/code/dotfiles/config/nvim/lua/plugins/treesitter.lua
endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 79 - ((53 * winheight(0) + 32) / 64)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 79
normal! 02|
lcd ~/code/dotfiles/config/nvim
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 77 + 116) / 232)
exe 'vert 2resize ' . ((&columns * 76 + 116) / 232)
exe 'vert 3resize ' . ((&columns * 77 + 116) / 232)
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

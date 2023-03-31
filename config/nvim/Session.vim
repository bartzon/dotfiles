let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/code/dotfiles/config/bartzon_vim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +16 lua/plugins/telescope.lua
badd +31 lua/user/plugins.lua
badd +7 lua/plugins/open-browser.lua
badd +21 lua/plugins/treesitter.lua
badd +10 lua/plugins/null-lsp.lua
badd +6 lua/user/keymaps.lua
badd +66 lua/plugins/lsp/init.lua
badd +3 lua/plugins/init.lua
badd +6 lua/plugins/which-key.lua
badd +28 lua/plugins/copilot.lua
badd +0 lua/user/indent-blankline.lua
argglobal
%argdel
edit lua/user/indent-blankline.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
wincmd _ | wincmd |
vsplit
4wincmd h
wincmd w
wincmd w
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
exe 'vert 1resize ' . ((&columns * 67 + 168) / 336)
exe 'vert 2resize ' . ((&columns * 66 + 168) / 336)
exe 'vert 3resize ' . ((&columns * 66 + 168) / 336)
exe 'vert 4resize ' . ((&columns * 67 + 168) / 336)
exe 'vert 5resize ' . ((&columns * 66 + 168) / 336)
argglobal
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
let s:l = 18 - ((17 * winheight(0) + 33) / 66)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 18
normal! 013|
lcd ~/code/dotfiles/config/bartzon_vim
wincmd w
argglobal
if bufexists(fnamemodify("~/code/dotfiles/config/bartzon_vim/lua/user/keymaps.lua", ":p")) | buffer ~/code/dotfiles/config/bartzon_vim/lua/user/keymaps.lua | else | edit ~/code/dotfiles/config/bartzon_vim/lua/user/keymaps.lua | endif
if &buftype ==# 'terminal'
  silent file ~/code/dotfiles/config/bartzon_vim/lua/user/keymaps.lua
endif
balt ~/code/dotfiles/config/bartzon_vim/lua/plugins/copilot.lua
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
let s:l = 6 - ((5 * winheight(0) + 33) / 66)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 6
normal! 0
lcd ~/code/dotfiles/config/bartzon_vim
wincmd w
argglobal
if bufexists(fnamemodify("~/code/dotfiles/config/bartzon_vim/lua/plugins/which-key.lua", ":p")) | buffer ~/code/dotfiles/config/bartzon_vim/lua/plugins/which-key.lua | else | edit ~/code/dotfiles/config/bartzon_vim/lua/plugins/which-key.lua | endif
if &buftype ==# 'terminal'
  silent file ~/code/dotfiles/config/bartzon_vim/lua/plugins/which-key.lua
endif
balt ~/code/dotfiles/config/bartzon_vim/lua/plugins/init.lua
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
let s:l = 6 - ((5 * winheight(0) + 33) / 66)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 6
normal! 022|
lcd ~/code/dotfiles/config/bartzon_vim
wincmd w
argglobal
if bufexists(fnamemodify("~/code/dotfiles/config/bartzon_vim/lua/plugins/treesitter.lua", ":p")) | buffer ~/code/dotfiles/config/bartzon_vim/lua/plugins/treesitter.lua | else | edit ~/code/dotfiles/config/bartzon_vim/lua/plugins/treesitter.lua | endif
if &buftype ==# 'terminal'
  silent file ~/code/dotfiles/config/bartzon_vim/lua/plugins/treesitter.lua
endif
balt ~/code/dotfiles/config/bartzon_vim/lua/plugins/null-lsp.lua
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
let s:l = 10 - ((2 * winheight(0) + 33) / 66)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 10
normal! 0
lcd ~/code/dotfiles/config/bartzon_vim
wincmd w
argglobal
if bufexists(fnamemodify("~/code/dotfiles/config/bartzon_vim/lua/plugins/telescope.lua", ":p")) | buffer ~/code/dotfiles/config/bartzon_vim/lua/plugins/telescope.lua | else | edit ~/code/dotfiles/config/bartzon_vim/lua/plugins/telescope.lua | endif
if &buftype ==# 'terminal'
  silent file ~/code/dotfiles/config/bartzon_vim/lua/plugins/telescope.lua
endif
balt ~/code/dotfiles/config/bartzon_vim/lua/user/plugins.lua
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
let s:l = 10 - ((9 * winheight(0) + 33) / 66)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 10
normal! 02|
wincmd w
exe 'vert 1resize ' . ((&columns * 67 + 168) / 336)
exe 'vert 2resize ' . ((&columns * 66 + 168) / 336)
exe 'vert 3resize ' . ((&columns * 66 + 168) / 336)
exe 'vert 4resize ' . ((&columns * 67 + 168) / 336)
exe 'vert 5resize ' . ((&columns * 66 + 168) / 336)
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
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :

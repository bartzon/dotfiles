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
badd +1 NetrwTreeListing
badd +1 ~/code/dotfiles/config/nvim
badd +48 lua/plugins/cmp.lua
badd +26 lua/plugins/lualine.lua
badd +12 lua/plugins/init.lua
badd +1 lua/plugins
badd +7 lua/plugins/which-key.lua
badd +7 lua/plugins/vim-test.lua
badd +8 init.lua
badd +4 lua/user/env.lua
badd +1 lua/user
badd +28 lua/plugins/lsp/init.lua
badd +1 lua/plugins/lsp
badd +12 lua/plugins/lsp/lsp.lua
badd +6 lua/plugins/lsp/init.lua_old
badd +1 lua/plugins/lsp.lua
badd +75 lua/plugins/treesitter.lua
badd +2 man://builtin(1)
badd +1 man://local(8)
badd +31 lua/user/commands.lua
badd +7 lua/plugins/copilot.lua
badd +1 lua/plugins/null-lsp.lua
badd +1 lua/plugins/lsp/lsp_zero.lua
badd +27 lua/plugins/lsp_zero.lua
badd +27 lua/plugins/lsp_config.lua
badd +0 option-window
badd +3 lua/plugins/noice.lua
argglobal
%argdel
edit option-window
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
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
wincmd =
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
let s:l = 1 - ((0 * winheight(0) + 34) / 69)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
lcd ~/code/dotfiles/config/nvim
wincmd w
argglobal
if bufexists(fnamemodify("~/code/dotfiles/config/nvim/lua/plugins/noice.lua", ":p")) | buffer ~/code/dotfiles/config/nvim/lua/plugins/noice.lua | else | edit ~/code/dotfiles/config/nvim/lua/plugins/noice.lua | endif
if &buftype ==# 'terminal'
  silent file ~/code/dotfiles/config/nvim/lua/plugins/noice.lua
endif
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
let s:l = 3 - ((2 * winheight(0) + 34) / 69)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 3
normal! 0
wincmd w
2wincmd w
wincmd =
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=1
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

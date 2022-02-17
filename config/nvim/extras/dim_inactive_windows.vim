hi InactiveWindow guibg=#282828

" Call method on window enter
augroup WindowManagement
  autocmd!
  autocmd WinEnter * call HandleWinEnter()
augroup END

" Change highlight group of active/inactive windows
function! HandleWinEnter()
  setlocal winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
endfunction


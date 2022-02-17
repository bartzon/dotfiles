function! s:get_alternate()
  " strip path and extension from current file
  let fname = expand('%:t:r')

  " foo.rb => foo_test.rb => foo.rb
  if fname =~ '_test'
    return substitute(fname , '_test', '.rb', '')
  else
    return fname . '_test.rb'
endfunction

command! A call fzf#run({ 'options': '--select-1 --query ' . s:get_alternate() . '$', 'sink': 'e' })
command! AH call fzf#run({ 'options': '--select-1 --query ' . s:get_alternate() . '$', 'sink': 'spl' })
command! AV call fzf#run({ 'options': '--select-1 --query ' . s:get_alternate() . '$', 'sink': 'vspl' })

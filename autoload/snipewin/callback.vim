function! s:close(winid) abort
  call win_execute(a:winid, 'close')
endfunction
let g:snipewin#callback#close = function('s:close')

function s:hide(winid)
  call win_execute(a:winid, 'hide')
endfunction
let g:snipewin#callback#hide = function('s:hide')

function! s:only(winid) abort
  call win_execute(a:winid, 'only')
endfunction
let g:snipewin#callback#only = function('s:only')

function! s:swap(winid) abort
  let [current, target] = [bufnr(), winbufnr(a:winid)]
  execute 'buffer' target
  call win_execute(a:winid, 'buffer ' .. current)
endfunction
let g:snipewin#callback#swap = function('s:swap')

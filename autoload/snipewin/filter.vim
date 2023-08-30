let s:msg = '%s expects list but got number. Probubbly you treat as non-higher-ordrer function.'
function! s:filetype(filetypes) abort
  if type(a:filetypes) ==# v:t_number
    call snipewin#_echoerr('g:snipewin#filter#filetype'->printf(s:msg))
    return v:true
  endif
  return { winid -> index(a:filetypes, getwinvar(winid, '&filetype')) < 0 }
endfunction
let g:snipewin#filter#filetype = function('s:filetype')

let g:snipewin#filter#floatwin = { winid -> empty(nvim_win_get_config(winid).relative) }

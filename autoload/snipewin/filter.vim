let s:msg = '%s expects list but got number. Probubbly you treat as non-higher-ordrer function.'
function! snipewin#filter#filetype(filetypes) abort
  if type(a:filetypes) ==# v:t_number
    call snipewin#_echoerr('snipewin#filter#filetype'->printf(s:msg))
    return v:true
  endif
  return { winid -> index(a:filetypes, getwinvar(winid, '&filetype')) < 0 }
endfunction

function! snipewin#filter#floatwin(winid) abort
  return empty(nvim_win_get_config(winid).relative)
endfunction

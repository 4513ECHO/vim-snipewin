" @return winid[]
function! snipewin#vim#list_win() abort
  return range(1, tabpagenr()->tabpagewinnr('$'))->map({ -> win_getid(v:val) })
endfunction

" @param winid winid
" @param label { text: string[], width: integer, height: integer }
" @return winid
function! snipewin#vim#create_label(winid, label) abort
  let [row, col] = win_screenpos(a:winid)
  return popup_create(a:label.text, #{
        \ line: row + (winheight(a:winid) - a:label.height) / 2,
        \ col: col + (winwidth(a:winid) - a:label.width) / 2,
        \ highlight: 'SnipeWinLabel',
        \ }->extend(g:snipewin_override_winopts))
endfunction

" @param labels { label: winid }[]
function! snipewin#vim#clear_label(labels) abort
  call map(copy(a:labels), { -> popup_close(v:val.label) })
endfunction

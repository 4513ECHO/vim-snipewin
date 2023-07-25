" @return winid[]
function! teleportwin#vim#list() abort
  return range(1, winnr('$'))->map({ _, winnr -> win_getid(winnr) })
endfunction

" @param winnr winnr
" @param label { text: string[], width: integer, height: integer }
" @return winid
function! teleportwin#vim#create_label(winnr, label) abort
  let [row, col] = win_screenpos(a:winnr)
  return popup_create(a:label.text, #{
        \ line: row + (winheight(a:winnr) - a:label.height) / 2,
        \ col: col + (winwidth(a:winnr) - a:label.width) / 2,
        \ highlight: 'TeleportWinLabel',
        \ }->extend(g:teleportwin_override_winopts))
endfunction

" @param labels { label: winid }[]
function! teleportwin#vim#clear_label(labels) abort
  call map(copy(a:labels), { _, label -> popup_close(label.label) })
endfunction

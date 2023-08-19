" @return winid[]
function! snipewin#nvim#list_win() abort
  return nvim_tabpage_list_wins(0)->filter({ -> nvim_win_get_config(v:val).focusable })
endfunction

" @param winnr winnr
" @param label { text: string[], width: integer, height: integer }
" @return winid
function! snipewin#nvim#create_label(winnr, label) abort
  let bufnr = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(bufnr, 0, -1, v:true, a:label.text)

  let winid = nvim_open_win(bufnr, v:false, #{
        \ relative: 'win',
        \ win: win_getid(a:winnr),
        \ width: a:label.width,
        \ height: a:label.height,
        \ row: (winheight(a:winnr) - a:label.height) / 2,
        \ col: (winwidth(a:winnr) - a:label.width) / 2,
        \ focusable: v:false,
        \ style: 'minimal',
        \ }->extend(g:snipewin_override_winopts))
  call nvim_set_option_value('winhighlight', 'NormalFloat:SnipeWinLabel', #{ win: winid })

  return winid
endfunction

" @param labels { label: winid }[]
function! snipewin#nvim#clear_label(labels) abort
  call map(copy(a:labels), { -> nvim_win_close(v:val.label, v:true) })
endfunction

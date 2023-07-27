let s:host = has('nvim') ? 'nvim' : 'vim'

function! snipewin#select(callback = g:snipewin#callback#default) abort
  let fonts = snipewin#font#load(g:snipewin_label_font)
  let label = g:snipewin_label_chars->split('\zs')
  let label_idx = 0
  " @type Record<string, { label: winid, target: winid }>
  let label_win = {}

  let targets = snipewin#{s:host}#list_win()
  if g:snipewin_ignore_single && len(targets) ==# 1
    return
  endif
  for target in targets
    if label_idx >= len(label)
      call snipewin#_echoerr('Window overflows the length of label. Stop labeling...')
      break
    endif
    let label_win[label[label_idx]] = #{
          \ label: snipewin#{s:host}#create_label(win_id2win(target), fonts[label[label_idx]]),
          \ target: target,
          \ }
    let label_idx += 1
  endfor

  redraw
  let selected = getcharstr()->toupper()

  call snipewin#{s:host}#clear_label(label_win->values())
  let winid = label_win->get(selected, {})->get('target')
  if winid || v:mouse_winid
    return a:callback(winid ? winid : v:mouse_winid)
  endif
  return v:null
endfunction

function! snipewin#_echoerr(msg) abort
  echohl WarningMsg
  echomsg '[snipewin]' a:msg
  echohl None
endfunction

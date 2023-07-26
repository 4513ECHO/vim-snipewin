let s:host = has('nvim') ? 'nvim' : 'vim'

function! snipewin#select(callback = function('win_gotoid')) abort
  let fonts = snipewin#font#{g:snipewin_label_size}()
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
      echohl WarningMsg
      echomsg '[snipewin] Window overflows the length of label. Stop labeling...'
      echohl None
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
  let winid = label_win->get(selected, {})->get('target', v:null)
  if winid isnot# v:null
    call a:callback(winid)
  endif
endfunction

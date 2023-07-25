let s:host = has('nvim') ? 'nvim' : 'vim'

function! teleportwin#select(callback = function('win_gotoid')) abort
  let fonts = teleportwin#font#{g:teleportwin_label_size}()
  let label = g:teleportwin_label_chars->split('\zs')
  let label_idx = 0
  " @type Record<string, { label: winid, target: winid }>
  let label_win = {}

  let targets = teleportwin#{s:host}#list()
  if g:teleportwin_ignore_single && len(targets) ==# 1
    return
  endif
  for target in targets
    let label_win[label[label_idx]] = #{
          \ label: teleportwin#{s:host}#create_label(win_id2win(target), fonts[label[label_idx]]),
          \ target: target,
          \ }
    let label_idx += 1
  endfor

  redraw | echo 'teleportwin > '
  let selected = getcharstr()->toupper()
  echo '' | redraw

  call teleportwin#{s:host}#clear_label(label_win->values())
  let winid = label_win->get(selected, {})->get('target', v:null)
  if winid isnot# v:null
    call a:callback(winid)
  endif
endfunction

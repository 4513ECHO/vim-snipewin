function! snipewin#callback#close(winid) abort
  return win_execute(a:winid, 'close')
endfunction

function! snipewin#callback#hide(winid) abort
  return win_execute(a:winid, 'hide')
endfunction

function! snipewin#callback#goto(winid) abort
  return win_gotoid(a:winid)
endfunction

function! snipewin#callback#only(winid) abort
  return win_execute(a:winid, 'only')
endfunction

let g:snipewin#callback#default = g:->get(
      \ 'snipewin#callback#default',
      \ function('snipewin#callback#goto'),
      \ )

function! snipewin#callback#swap(winid) abort
  let current = win_getid()
  if current !=# a:winid && winnr('$') <= 2
    wincmd x
    return
  endif
  let target = s:find_wincmd_x_target(winlayout(), current, a:winid)
  if target
    execute target 'wincmd x'
    return
  endif
  let current = winbufnr(current)
  execute 'hide buffer' winbufnr(a:winid)
  call win_execute(a:winid, 'hide buffer ' .. current)
endfunction

" Original: https://github.com/atusy/dotfiles/blob/1c57fd77/dot_config/nvim/lua/plugins/chowcho.lua#L83-L96
"  License: MIT, https://github.com/atusy/dotfiles/blob/1c57fd77/LICENSE.md
function! s:find_wincmd_x_target(layout, current, target) abort
  if a:layout[0] ==# 'leaf'
    return
  endif
  let leaves = {}
  for [idx, item] in a:layout[1]->map({ i, v -> [i, v] })
    if item[0] ==# 'leaf'
      let leaves[item[1]] = idx + 1
    else
      let result = s:find_wincmd_x_target(item, a:current, a:target)
      if result
        return result
      endif
    endif
  endfor
  return leaves->has_key(a:current) ? leaves->get(a:target) : 0
endfunction

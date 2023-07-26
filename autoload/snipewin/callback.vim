let g:snipewin#callback#close = { winid -> win_execute(winid, 'close') }

let g:snipewin#callback#hide = { winid -> win_execute(winid, 'hide') }

let g:snipewin#callback#only = { winid -> win_execute(winid, 'only') }

function! s:swap(winid) abort
  let current = win_getid()
  if current !=# a:winid && winnr('$') <= 2
    wincmd x
    return
  endif
  let count = s:find_wincmd_x_target(winlayout(), current, a:winid)
  if count
    execute count 'wincmd x'
    return
  endif
  let current = winbufnr(current)
  execute 'hide buffer' winbufnr(a:winid)
  call win_execute(a:winid, 'hide buffer ' .. current)
endfunction
let g:snipewin#callback#swap = function('s:swap')

" Original: https://github.com/atusy/dotfiles/blob/effe2521/dot_config/nvim/lua/plugins/chowcho.lua#L83-L96
"  License: MIT, https://github.com/atusy/dotfiles/blob/effe2521/LICENSE.md
function! s:find_wincmd_x_target(layout, current, target) abort
  let leaves = {}
  let idx = 1
  for item in a:layout[1]
    if item[0] ==# 'leaf'
      let leaves[item[1]] = idx
    else
      let result = s:find_wincmd_x_target(item, a:current, a:target)
      if result
        return result
      endif
    endif
    let idx += 1
  endfor
  return leaves->has_key(a:current) ? leaves->get(a:target) : 0
endfunction

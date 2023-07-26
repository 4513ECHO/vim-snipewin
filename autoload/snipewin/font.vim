let s:chars = range(33, 126)->map({ _, nr -> nr2char(nr) })

let s:data_small = expand('<sfile>:h') .. '/data/small'
let s:data_large = expand('<sfile>:h') .. '/data/large'

function! s:read_data(file) abort
  let R = s:chars->reduce({ acc, key ->
        \ [execute('let acc[key] = []'), acc][-1] }, {})
  let lines = readfile(a:file)
  for c in s:chars
    while v:true
      let line = remove(lines, 0)
      if line =~# '\v^---'
        break
      endif
      call add(R[c], line)
    endwhile
  endfor
  return R
endfunction

function! s:get_font(type) abort
  if !exists('s:cache_' .. a:type)
    let s:cache_{a:type} = s:read_data(s:data_{a:type})
          \ ->map({ _, text -> #{
          \   text: text,
          \   height: len(text),
          \   width: len(text[0]),
          \ } })
  endif
  return s:cache_{a:type}
endfunction

function! snipewin#font#small() abort
  return s:get_font('small')
endfunction

function! snipewin#font#large() abort
  return s:get_font('large')
endfunction

" {'!'..'~'}
let s:chars = range(33, 126)->map({ _, nr -> nr2char(nr) })
let s:cache = {}
let s:file = #{
      \ small: expand('<sfile>:h') .. '/data/small',
      \ large: expand('<sfile>:h') .. '/data/large',
      \ }

function! s:read_data(file) abort
  " NOTE: Initialize Record<s:chars, string[]>
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

function! snipewin#font#load(name) abort
  if !has_key(s:cache, a:name)
    let s:cache[a:name] = s:read_data(s:file[a:name])
          \ ->map({ _, text -> #{
          \   text: text,
          \   height: len(text),
          \   width: len(text[0]),
          \ } })
  endif
  return s:cache[a:name]
endfunction

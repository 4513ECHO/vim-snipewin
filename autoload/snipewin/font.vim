" {'!'..'~'}
let s:chars = range(char2nr('A'), char2nr('Z'))->map({ _, nr -> nr2char(nr) })
let s:cache = {}
let s:file = #{
      \ asciian: expand('<sfile>:h') .. '/data/asciian_9_15.txt',
      \ }

function! s:read_data(file) abort
  " NOTE: Initialize Record<s:chars, string[]>
  let R = s:chars->reduce({ acc, key ->
        \ [execute('let acc[key] = []'), acc][-1] }, {})
  let lines = readfile(a:file)

  for _ in range(0, 2) " Skip a header and a blank griph
    while v:true
      let line = remove(lines, 0)
      if empty(line)
        break
      endif
    endwhile
  endfor

  for c in s:chars
    while v:true
      let line = remove(lines, 0)
      if empty(line)
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

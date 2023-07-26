" Sequence of 'A' to 'Z'
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

  for _ in range(0, 1) " Skip a header and a blank griph
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

function! s:invert_font(text) abort
  let result = []
  for line in a:text
    let line = substitute(line, ' ', '@', 'g')
    let line = substitute(line, '#', ' ', 'g')
    let line = substitute(line, '@', '#', 'g')
    call add(result, line)
  endfor
  return result
endfunction

function! snipewin#font#load(name) abort
  if !has_key(s:cache, a:name)
    if a:name =~# '_inverted$'
      let name = substitute(a:name, '_inverted', '', '')
      let s:cache[a:name] = s:read_data(s:file[name])
            \ ->map({ _, text -> #{
            \   text: s:invert_font(text),
            \   height: len(text),
            \   width: len(text[0]),
            \} })
    else
      let s:cache[a:name] = s:read_data(s:file[a:name])
            \ ->map({ _, text -> #{
            \   text: text,
            \   height: len(text),
            \   width: len(text[0]),
            \ } })
    endif
  endif
  return s:cache[a:name]
endfunction

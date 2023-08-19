" Sequence of 'A' to 'Z'
let s:chars = range(char2nr('A'), char2nr('Z'))->map({ -> nr2char(v:val) })
let s:cache = {}
let s:file = #{
      \ asciian: expand('<sfile>:h') .. '/data/asciian_9_15.txt',
      \ }

function! s:read_chunk(lines, result = []) abort
  while v:true
    let line = remove(a:lines, 0)
    if empty(line)
      break
    endif
    call add(a:result, line)
  endwhile
endfunction

function! s:read_data(file) abort
  " NOTE: Initialize Record<s:chars, string[]>
  let R = s:chars->reduce({ acc, key ->
        \ [execute('let acc[key] = []'), acc][-1] }, {})
  let lines = readfile(a:file)

  " Skip a header and a blank griph
  call range(2)->map({ -> s:read_chunk(lines) })

  call copy(s:chars)->map({ -> s:read_chunk(lines, R[v:val]) })
  return R
endfunction

function! s:invert_font(text) abort
  return a:text->map({ _, line -> line
        \ ->substitute(' ', '@', 'g')
        \ ->substitute('#', ' ', 'g')
        \ ->substitute('@', '#', 'g')
        \ })
endfunction

function! s:replace_font(font, pixel) abort
  if a:pixel ==# '#'
    return a:font
  endif
  return a:font->deepcopy()->map({ -> extend(v:val, #{
        \ text: v:val.text->map({ -> v:val->substitute('#', a:pixel, 'g') })
        \ }) })
endfunction

function! snipewin#font#load(name) abort
  if !has_key(s:cache, a:name)
    if a:name =~# '_inverted$'
      let name = a:name->substitute('_inverted$', '', '')
      let s:cache[a:name] = s:read_data(s:file[name])
            \ ->map({ _, text -> #{
            \   text: s:invert_font(text),
            \   height: len(text),
            \   width: len(text[0]),
            \ } })
    else
      let s:cache[a:name] = s:read_data(s:file[a:name])
            \ ->map({ _, text -> #{
            \   text: text,
            \   height: len(text),
            \   width: len(text[0]),
            \ } })
    endif
  endif
  return s:cache[a:name]->s:replace_font(g:snipewin_label_pixel)
endfunction

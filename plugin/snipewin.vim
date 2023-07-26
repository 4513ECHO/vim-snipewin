if exists('g:loaded_snipewin')
  finish
endif
let g:loaded_snipewin = v:true

let g:snipewin_ignore_single = g:->get('snipewin_ignore_single', v:false)
let g:snipewin_label_chars = g:->get('snipewin_label_chars', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ')
let g:snipewin_label_font = g:->get('snipewin_label_font', 'asciian')
let g:snipewin_override_winopts = g:->get('snipewin_override_winopts', {})

augroup snipewin
  autocmd!
  autocmd ColorScheme * hi def link SnipeWinLabel Label
augroup END
hi def link SnipeWinLabel Label

nnoremap <Plug>(snipewin) <Cmd>call snipewin#select()<CR>

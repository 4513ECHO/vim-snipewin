if exists('g:loaded_teleportwin')
  finish
endif
let g:loaded_teleportwin = v:true

let g:teleportwin_label_chars = g:->get('teleportwin_label_chars', 'ABCDEFGHIJKLMNOPQRTUVWXYZ')
let g:teleportwin_label_size = g:->get('teleportwin_label_size', 'large')
let g:teleportwin_ignore_single = g:->get('teleportwin_ignore_single', v:false)
let g:teleportwin_override_winopts = g:->get('teleportwin_override_winopts', {})

augroup teleportwin
  autocmd!
  autocmd ColorScheme * hi def link TeleportWinLabel Label
augroup END
hi def link TeleportWinLabel Label

nnoremap <Plug>(teleportwin) <Cmd>call teleportwin#select()<CR>

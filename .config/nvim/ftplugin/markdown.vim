" Only do this when not yet done for this buffer
if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" Specify format for comments (lists, quotes)
setlocal comments+=fb:*  " Bulleted lists
setlocal comments+=fb:-  " Dashed lists
setlocal comments+=fb:+  " Plussed lists (?)
setlocal comments+=n:>   " Mail-style quotes
let &l:commentstring = '> %s'
let b:undo_ftplugin = 'setlocal comments< commentstring<'

" Specify format options (Tim Pope)
setlocal formatoptions+=n
let &l:formatlistpat = '^\s*\d\+\.\s\+\|^[-*+]\s\+\|^\[^\ze[^\]]\+\]:'
let b:undo_ftplugin .= '|setlocal formatoptions< formatlistpat<'

" Let's try this heading-based fold method out (Tim Pope)
function! MarkdownFold()
  let line = getline(v:lnum)

  " Regular headers
  let depth = match(line, '\(^#\+\)\@<=\( .*$\)\@=')
  if depth > 0
    return '>' . depth
  endif

  " Setext style headings
  if line =~# '^.\+$'
    let nextline = getline(v:lnum + 1)
    if nextline =~# '^=\+$'
      return '>1'
    elseif nextline =~# '^-\+$'
      return '>2'
    endif
  endif

  return '='
endfunction
let b:undo_ftplugin .= '|delfunction MarkdownFold'
setlocal foldexpr=MarkdownFold()
setlocal foldmethod=expr
setlocal foldlevel=99
let b:undo_ftplugin .= '|setlocal foldexpr< foldmethod< foldlevel<'

" Spellcheck documents we're actually editing (not just viewing)
if &modifiable && !&readonly
  setlocal spell
  let b:undo_ftplugin .= '|setlocal spell<'
endif

" Tolerate leading lowercase letters in README.md files, for things like
" headings being filenames
if expand('%:t') ==# 'README.md'
  setlocal spellcapcheck=
  let b:undo_ftplugin .= '|setlocal spellcapcheck<'
endif

" From vim's mail.vim
let b:undo_ftplugin = "setl tw<"

if &tw == 0
  setlocal tw=78
endif

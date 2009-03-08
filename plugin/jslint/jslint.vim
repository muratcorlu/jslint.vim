function! s:JSLint() range
  if exists('b:errors')
    for error in b:errors
      call matchdelete(error)
    endfor
  endif

  let b:errors = []

  echo a:firstline
  echo a:lastline

  " Get range
  if !(a:firstline == 1 && a:lastline == '$')
    let b:firstline = a:firstline
    let b:lastline = a:lastline
  endif
    echo :'<
  echo b:firstline
  echo b:lastline

  " Set up command and parameters
  let s:plugin_path = '"' . expand("~/") . '"'
  if has("win32")
    let s:cmd = 'cscript'
    let s:plugin_path = s:plugin_path . "vimfiles"
    let s:runjslint_ext = 'wsf'
  else
    let s:cmd = 'js'
    let s:plugin_path = s:plugin_path . ".vim"
    let s:runjslint_ext = 'js'
  endif
  let s:plugin_path = s:plugin_path . "/plugin/jslint/"
  let s:cmd = "cd " . s:plugin_path . " && " . s:cmd . " " . s:plugin_path 
              \ . "runjslint." . s:runjslint_ext

  let b:jslint_output = system(s:cmd, join(getline(b:firstline, b:lastline)
              \ , "\n") . "\n")

  for error in split(b:jslint_output, "\n")
    let b:parts = matchlist(error, "line\\s\\+\\(\\d\\+\\)\\s\\+")
    if !empty(b:parts)
      call add(b:errors, matchadd('Error', '\%'.b:parts[1].'l'))
    elseif error == "All Good."
      echo "JSLint: " . error
    endif
  endfor
endfunction

command! -range=% JSLint :call s:JSLint()


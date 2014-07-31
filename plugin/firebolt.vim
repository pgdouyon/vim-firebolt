if exists("g:loaded_firebolt")
    finish
endif
let g:loaded_firebolt = 1

let s:save_cpo = &cpoptions
set cpoptions&vim

function! s:Firebolt(forward, inclusive, operator)
    let c1 = getchar()
    let c2 = getchar()
    let char_one = type(c1) ? c1 : nr2char(c1)
    let char_two = type(c2) ? c2 : nr2char(c2)
    let char_two = (char_two == "\r") ? "" : char_two
    let Find_char = a:operator ? function("<SID>FindCharOp") : function("<SID>FindChar")
    let s:firebolt = {'forward': a:forward, 'inclusive': a:inclusive,
        \ 'char_one': char_one, 'char_two': char_two, 'find_char': Find_char}
    call s:firebolt.find_char()
endfunction


function! s:FindChar() dict
    if self.inclusive
        let pattern = '\V'.self.char_one . self.char_two.'\.'
    else
        let pattern = '\V\.'.self.char_one . self.char_two.'\.'
    endif
    let flags = 'W'
    let flags .= self.forward ? '' : 'b'
    let flags .= (!self.forward && !self.inclusive) ? 'e' : ''
    call search(pattern, flags, line("."))
endfunction


function! s:FindCharOp() dict
    let pattern = '\V'.self.char_one . self.char_two.'\.'
    let flags = 'W'
    let flags .= self.forward ? '' : 'b'
    let flags .= (self.forward == self.inclusive) ? 'e' : ''
    call search(pattern, flags, line("."))
endfunction


function! s:RepeatFind(forward, operator)
    if !exists("s:firebolt")
        return
    endif
    let dir = s:firebolt.forward
    let s:firebolt.forward = a:forward ? dir : !dir
    let s:firebolt.find_char = a:operator ? function("<SID>FindCharOp") : function("<SID>FindChar")
    call s:firebolt.find_char()
    let s:firebolt.forward = dir
endfunction


function! s:Seek(forward, operator)
    let c1 = getchar()
    let c1 = type(c1) ? c1 : nr2char(c1)
    let seek_table = {'b': '(\|)', 'B': '{\|}', 'a': '<\|>', 'r': '[\|]'}
    let seek_char = get(seek_table, c1, c1)
    let Find_char = a:operator ? function("<SID>FindCharOp") : function("<SID>FindChar")
    let s:firebolt = {'forward': a:forward, 'inclusive': !a:operator,
        \ 'char_one': seek_char, 'char_two': "", 'find_char': Find_char}
    call s:firebolt.find_char()
endfunction

noremap <silent> f :call <SID>Firebolt(1, 1, 0)<CR>
noremap <silent> F :call <SID>Firebolt(0, 1, 0)<CR>
noremap <silent> t :call <SID>Firebolt(1, 0, 0)<CR>
noremap <silent> T :call <SID>Firebolt(0, 0, 0)<CR>
noremap <silent> ; :call <SID>RepeatFind(1, 0)<CR>
noremap <silent> , :call <SID>RepeatFind(0, 0)<CR>

onoremap <silent> f :call <SID>Firebolt(1, 1, 1)<CR>
onoremap <silent> F :call <SID>Firebolt(0, 1, 1)<CR>
onoremap <silent> t :call <SID>Firebolt(1, 0, 1)<CR>
onoremap <silent> T :call <SID>Firebolt(0, 0, 1)<CR>
onoremap <silent> ; :call <SID>RepeatFind(1, 1)<CR>
onoremap <silent> , :call <SID>RepeatFind(0, 1)<CR>

noremap <silent> s :call <SID>Seek(1, 0)<CR>
noremap <silent> S :call <SID>Seek(0, 0)<CR>
onoremap <silent> s :call <SID>Seek(1, 1)<CR>
onoremap <silent> S :call <SID>Seek(0, 1)<CR>

let &cpoptions = s:save_cpo
unlet s:save_cpo

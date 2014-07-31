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
    let s:find_args = {'forward': a:forward, 'inclusive': a:inclusive,
        \ 'char_one': char_one, 'char_two': char_two, 'find_char': Find_char}
    call s:find_args.find_char()
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
    if !exists("s:find_args")
        return
    endif
    let dir = s:find_args.forward
    let s:find_args.forward = a:forward ? dir : !dir
    let s:find_args.find_char = a:operator ? function("<SID>FindCharOp") : function("<SID>FindChar")
    call s:find_args.find_char()
    let s:find_args.forward = dir
endfunction

nnoremap f :call <SID>Firebolt(1, 1, 0)<CR>
nnoremap F :call <SID>Firebolt(0, 1, 0)<CR>
nnoremap t :call <SID>Firebolt(1, 0, 0)<CR>
nnoremap T :call <SID>Firebolt(0, 0, 0)<CR>
onoremap f :call <SID>Firebolt(1, 1, 1)<CR>
onoremap F :call <SID>Firebolt(0, 1, 1)<CR>
onoremap t :call <SID>Firebolt(1, 0, 1)<CR>
onoremap T :call <SID>Firebolt(0, 0, 1)<CR>

nnoremap ; :call <SID>RepeatFind(1, 0)<CR>
nnoremap , :call <SID>RepeatFind(0, 0)<CR>
onoremap ; :call <SID>RepeatFind(1, 1)<CR>
onoremap , :call <SID>RepeatFind(0, 1)<CR>

let &cpoptions = s:save_cpo
unlet s:save_cpo

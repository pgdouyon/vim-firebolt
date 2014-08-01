"==============================================================================
"File:        firebolt.vim
"Description: Enhanced f/t motions.  Replaces default f/t with a two character
"             search on the same line.  Also remaps the s key to a one-char
"             search for '(,{,<,]' using 'b,B,a,r' keys.
"Maintainer:  Pierre-Guy Douyon <pgdouyon@alum.mit.edu>
"Version:     1.0.0
"Last Change: 2014-07-31
"License:     MIT <../LICENSE>
"==============================================================================

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

    function! s:FwdRepeat(forward)
        let fwd = s:firebolt.forward
        let s:firebolt.forward = a:forward ? fwd : !fwd
    endfunction
    function! s:OpRepeat(operator)
        return
    endfunction
    let s:firebolt = {'forward': a:forward, 'inclusive': a:inclusive,
        \ 'char_one': char_one, 'char_two': char_two, 'find_char': Find_char,
        \ 'fwd_repeat': function("<SID>FwdRepeat"), 'op_repeat': function("<SID>OpRepeat")}
    for _ in range(v:count1)
        call s:firebolt.find_char()
    endfor
endfunction


function! s:FindChar() dict
    if self.inclusive
        let pattern = '\V'.self.char_one . self.char_two.'\.\?'
    else
        let pattern = '\V\.\?'.self.char_one . self.char_two.'\.\?'
    endif
    let flags = 'W'
    let flags .= self.forward ? '' : 'b'
    let flags .= (!self.forward && !self.inclusive) ? 'e' : ''
    call search(pattern, flags, line("."))
endfunction


function! s:FindCharOp() dict
    let pattern = '\V'.self.char_one . self.char_two.'\.\?'
    let flags = 'W'
    let flags .= self.forward ? '' : 'b'
    let flags .= (self.forward == self.inclusive) ? 'e' : ''
    call search(pattern, flags, line("."))
    silent! call repeat#set(v:operator."\<Plug>Firebolt_;", v:count1)
endfunction


function! s:RepeatFind(forward, operator)
    if !exists("s:firebolt")
        return
    endif
    let fwd = s:firebolt.forward
    let s:firebolt.find_char = a:operator ? function("<SID>FindCharOp") : function("<SID>FindChar")
    call s:firebolt.fwd_repeat(a:forward)
    call s:firebolt.op_repeat(a:operator)
    for _ in range(v:count1)
        call s:firebolt.find_char()
    endfor
    let s:firebolt.forward = fwd
endfunction


function! s:Seek(forward, operator)
    let c1 = getchar()
    let c1 = type(c1) ? c1 : nr2char(c1)
    let seek_table = {'b': '(\|)', 'B': '{\|}', 'a': '<\|>', 'r': '[\|]'}
    let seek_char = get(seek_table, c1, c1)
    let Find_char = a:operator ? function("<SID>FindCharOp") : function("<SID>FindChar")

    function! s:FwdRepeat(forward)
        let fwd = s:firebolt.forward
        let s:firebolt.forward = a:forward ? fwd : !fwd
    endfunction
    function! s:OpRepeat(operator)
        let s:firebolt.inclusive = !a:operator
    endfunction
    let s:firebolt = {'forward': a:forward, 'inclusive': !a:operator,
        \ 'char_one': seek_char, 'char_two': "", 'find_char': Find_char,
        \ 'fwd_repeat': function("<SID>FwdRepeat"), 'op_repeat': function("<SID>OpRepeat")}
    for _ in range(v:count1)
        call s:firebolt.find_char()
    endfor
endfunction

nnoremap <silent> <Plug>Firebolt_f :<C-u>call <SID>Firebolt(1, 1, 0)<CR>
nnoremap <silent> <Plug>Firebolt_F :<C-u>call <SID>Firebolt(0, 1, 0)<CR>
nnoremap <silent> <Plug>Firebolt_t :<C-u>call <SID>Firebolt(1, 0, 0)<CR>
nnoremap <silent> <Plug>Firebolt_T :<C-u>call <SID>Firebolt(0, 0, 0)<CR>

vnoremap <silent> <Plug>Firebolt_f :<C-u>call <SID>Firebolt(1, 1, 0)<CR>
vnoremap <silent> <Plug>Firebolt_F :<C-u>call <SID>Firebolt(0, 1, 0)<CR>
vnoremap <silent> <Plug>Firebolt_t :<C-u>call <SID>Firebolt(1, 0, 0)<CR>
vnoremap <silent> <Plug>Firebolt_T :<C-u>call <SID>Firebolt(0, 0, 0)<CR>

onoremap <silent> <Plug>Firebolt_f :<C-u>call <SID>Firebolt(1, 1, 1)<CR>
onoremap <silent> <Plug>Firebolt_F :<C-u>call <SID>Firebolt(0, 1, 1)<CR>
onoremap <silent> <Plug>Firebolt_t :<C-u>call <SID>Firebolt(1, 0, 1)<CR>
onoremap <silent> <Plug>Firebolt_T :<C-u>call <SID>Firebolt(0, 0, 1)<CR>

nnoremap <silent> <Plug>Firebolt_s :<C-u>call <SID>Seek(1, 0)<CR>
nnoremap <silent> <Plug>Firebolt_S :<C-u>call <SID>Seek(0, 0)<CR>
vnoremap <silent> <Plug>Firebolt_s :<C-u>call <SID>Seek(1, 0)<CR>
vnoremap <silent> <Plug>Firebolt_S :<C-u>call <SID>Seek(0, 0)<CR>
onoremap <silent> <Plug>Firebolt_s :<C-u>call <SID>Seek(1, 1)<CR>
onoremap <silent> <Plug>Firebolt_S :<C-u>call <SID>Seek(0, 1)<CR>

nnoremap <silent> <Plug>Firebolt_; :<C-u>call <SID>RepeatFind(1, 0)<CR>
nnoremap <silent> <Plug>Firebolt_, :<C-u>call <SID>RepeatFind(0, 0)<CR>
vnoremap <silent> <Plug>Firebolt_; :<C-u>call <SID>RepeatFind(1, 0)<CR>
vnoremap <silent> <Plug>Firebolt_, :<C-u>call <SID>RepeatFind(0, 0)<CR>
onoremap <silent> <Plug>Firebolt_; :<C-u>call <SID>RepeatFind(1, 1)<CR>
onoremap <silent> <Plug>Firebolt_, :<C-u>call <SID>RepeatFind(0, 1)<CR>

if !exists("g:firebolt_no_mappings") || (g:firebolt_no_mappings == 0)
    map f <Plug>Firebolt_f
    map F <Plug>Firebolt_F
    map t <Plug>Firebolt_t
    map T <Plug>Firebolt_T
    map s <Plug>Firebolt_s
    map S <Plug>Firebolt_S
    map ; <Plug>Firebolt_;
    map , <Plug>Firebolt_,
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo

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

function! s:Firebolt(forward, inclusive, mode)
    let c1 = getchar()
    if (c1 == "\e")
        return
    endif
    let c2 = getchar()
    if (c2 == "\e")
        return
    endif
    let char_one = type(c1) ? c1 : nr2char(c1)
    let char_two = type(c2) ? c2 : nr2char(c2)
    let char_two = (char_two == "\r") ? "" : char_two

    let s:firebolt = {'forward': a:forward, 'inclusive': a:inclusive,
        \ 'char_one': char_one, 'char_two': char_two}
    call s:FireboltFind(a:mode)
endfunction


function! s:FireboltFind(mode)
    if a:mode ==? "o"
        let s:firebolt.find_char = function("<SID>FindCharOp")
    else
        let s:firebolt.find_char = function("<SID>FindChar")
    endif
    if a:mode ==? "v"
        normal! gv
    endif
    for _ in range(v:count1)
        call s:firebolt.find_char()
    endfor
endfunction


function! s:FindChar() dict
    let search = (self.char_one == '\') ? '\\' : self.char_one
    let search .= (self.char_two == '\') ? '\\' : self.char_two
    if self.inclusive
        let pattern = '\V'.search.'\.\?'
    else
        let pattern = '\V\.\?'.search.'\.\?'
    endif
    let flags = 'W'
    let flags .= self.forward ? '' : 'b'
    let flags .= (!self.forward && !self.inclusive) ? 'e' : ''
    call search(pattern, flags, line("."))
endfunction


function! s:FindCharOp() dict
    let search = (self.char_one == '\') ? '\\' : self.char_one
    let search .= (self.char_two == '\') ? '\\' : self.char_two
    let pattern = '\V'.search.'\.\?'
    let flags = 'W'
    let flags .= self.forward ? '' : 'b'
    let flags .= (self.forward == self.inclusive) ? 'e' : ''
    call search(pattern, flags, line("."))
    silent! call repeat#set(v:operator."\<Plug>Firebolt_;", v:count1)
endfunction


function! s:RepeatFind(forward, mode)
    if !exists("s:firebolt")
        return
    endif
    let fwd = s:firebolt.forward
    let s:firebolt.forward = a:forward ? fwd : !fwd
    if has_key(s:firebolt, 'repeat')
        call s:firebolt.repeat(a:forward, a:mode)
    endif
    call s:FireboltFind(a:mode)
    let s:firebolt.forward = fwd
endfunction


function! s:Seek(forward, mode)
    let c1 = getchar()
    let c1 = type(c1) ? c1 : nr2char(c1)
    let inclusive = (a:mode ==? "o") ? 0 : 1

    let s:firebolt = {'forward': a:forward, 'inclusive': inclusive,
        \ 'char_one': c1, 'char_two': "", 'repeat': function("<SID>SeekRepeat")}
    call s:FireboltFind(a:mode)
endfunction


function! s:SeekRepeat(forward, mode)
    let s:firebolt.inclusive = (a:mode ==? "o") ? 0 : 1
endfunction

nnoremap <silent> <Plug>Firebolt_f :<C-u>call <SID>Firebolt(1, 1, "n")<CR>
nnoremap <silent> <Plug>Firebolt_F :<C-u>call <SID>Firebolt(0, 1, "n")<CR>
nnoremap <silent> <Plug>Firebolt_t :<C-u>call <SID>Firebolt(1, 0, "n")<CR>
nnoremap <silent> <Plug>Firebolt_T :<C-u>call <SID>Firebolt(0, 0, "n")<CR>

vnoremap <silent> <Plug>Firebolt_f :<C-u>call <SID>Firebolt(1, 1, "v")<CR>
vnoremap <silent> <Plug>Firebolt_F :<C-u>call <SID>Firebolt(0, 1, "v")<CR>
vnoremap <silent> <Plug>Firebolt_t :<C-u>call <SID>Firebolt(1, 0, "v")<CR>
vnoremap <silent> <Plug>Firebolt_T :<C-u>call <SID>Firebolt(0, 0, "v")<CR>

onoremap <silent> <Plug>Firebolt_f :<C-u>call <SID>Firebolt(1, 1, "o")<CR>
onoremap <silent> <Plug>Firebolt_F :<C-u>call <SID>Firebolt(0, 1, "o")<CR>
onoremap <silent> <Plug>Firebolt_t :<C-u>call <SID>Firebolt(1, 0, "o")<CR>
onoremap <silent> <Plug>Firebolt_T :<C-u>call <SID>Firebolt(0, 0, "o")<CR>

nnoremap <silent> <Plug>Firebolt_r :<C-u>call <SID>Seek(1, "n")<CR>
nnoremap <silent> <Plug>Firebolt_R :<C-u>call <SID>Seek(0, "n")<CR>
vnoremap <silent> <Plug>Firebolt_r :<C-u>call <SID>Seek(1, "v")<CR>
vnoremap <silent> <Plug>Firebolt_R :<C-u>call <SID>Seek(0, "v")<CR>
onoremap <silent> <Plug>Firebolt_r :<C-u>call <SID>Seek(1, "o")<CR>
onoremap <silent> <Plug>Firebolt_R :<C-u>call <SID>Seek(0, "o")<CR>

nnoremap <silent> <Plug>Firebolt_; :<C-u>call <SID>RepeatFind(1, "n")<CR>
nnoremap <silent> <Plug>Firebolt_, :<C-u>call <SID>RepeatFind(0, "n")<CR>
vnoremap <silent> <Plug>Firebolt_; :<C-u>call <SID>RepeatFind(1, "v")<CR>
vnoremap <silent> <Plug>Firebolt_, :<C-u>call <SID>RepeatFind(0, "v")<CR>
onoremap <silent> <Plug>Firebolt_; :<C-u>call <SID>RepeatFind(1, "o")<CR>
onoremap <silent> <Plug>Firebolt_, :<C-u>call <SID>RepeatFind(0, "o")<CR>

if !exists("g:firebolt_no_mappings") || (g:firebolt_no_mappings == 0)
    map f <Plug>Firebolt_f
    map F <Plug>Firebolt_F
    map t <Plug>Firebolt_t
    map T <Plug>Firebolt_T
    map ; <Plug>Firebolt_;
    map , <Plug>Firebolt_,
    map r <Plug>Firebolt_r
    map R <Plug>Firebolt_R
    noremap s r
    noremap S R
endif

let &cpoptions = s:save_cpo
unlet s:save_cpo

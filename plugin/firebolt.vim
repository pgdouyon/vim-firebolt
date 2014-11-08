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
    let b:firebolt_find = 1
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


function! s:RepeatFind(repeat_cmd, mode)
    if exists("b:firebolt_find")
        let fwd = s:firebolt.forward
        let s:firebolt.forward = (a:repeat_cmd ==# ";") ? fwd : !fwd
        call s:FireboltFind(a:mode)
        let s:firebolt.forward = fwd
    else
        let operator = (a:mode ==? "o") ? v:operator : ""
        execute "normal! ".v:count1.operator.a:repeat_cmd
    endif
endfunction


function! s:LegacyFind(find_cmd, mode)
    if exists("b:firebolt_find")
        unlet b:firebolt_find
    endif
    let operator = (a:mode ==? "o") ? v:operator : ""
    let c1 = getchar()
    let char = type(c1) ? c1 : nr2char(c1)
    if strlen(char) == 1
        execute "normal! ".v:count1.operator.a:find_cmd.char
    endif
endfunction


nnoremap <silent> <Plug>Firebolt_f :<C-u>call <SID>LegacyFind("f", "n")<CR>
nnoremap <silent> <Plug>Firebolt_F :<C-u>call <SID>LegacyFind("F", "n")<CR>
nnoremap <silent> <Plug>Firebolt_t :<C-u>call <SID>LegacyFind("t", "n")<CR>
nnoremap <silent> <Plug>Firebolt_T :<C-u>call <SID>LegacyFind("T", "n")<CR>

vnoremap <silent> <Plug>Firebolt_f :<C-u>call <SID>LegacyFind("f", "v")<CR>
vnoremap <silent> <Plug>Firebolt_F :<C-u>call <SID>LegacyFind("F", "v")<CR>
vnoremap <silent> <Plug>Firebolt_t :<C-u>call <SID>LegacyFind("t", "v")<CR>
vnoremap <silent> <Plug>Firebolt_T :<C-u>call <SID>LegacyFind("T", "v")<CR>

onoremap <silent> <Plug>Firebolt_f :<C-u>call <SID>LegacyFind("f", "o")<CR>
onoremap <silent> <Plug>Firebolt_F :<C-u>call <SID>LegacyFind("F", "o")<CR>
onoremap <silent> <Plug>Firebolt_t :<C-u>call <SID>LegacyFind("t", "o")<CR>
onoremap <silent> <Plug>Firebolt_T :<C-u>call <SID>LegacyFind("T", "o")<CR>

nnoremap <silent> <Plug>Firebolt_r :<C-u>call <SID>Firebolt(1, 1, "n")<CR>
nnoremap <silent> <Plug>Firebolt_R :<C-u>call <SID>Firebolt(0, 1, "n")<CR>
vnoremap <silent> <Plug>Firebolt_r :<C-u>call <SID>Firebolt(1, 1, "v")<CR>
vnoremap <silent> <Plug>Firebolt_R :<C-u>call <SID>Firebolt(0, 1, "v")<CR>
onoremap <silent> <Plug>Firebolt_r :<C-u>call <SID>Firebolt(1, 1, "o")<CR>
onoremap <silent> <Plug>Firebolt_R :<C-u>call <SID>Firebolt(0, 1, "o")<CR>

nnoremap <silent> <Plug>Firebolt_; :<C-u>call <SID>RepeatFind(";", "n")<CR>
nnoremap <silent> <Plug>Firebolt_, :<C-u>call <SID>RepeatFind(",", "n")<CR>
vnoremap <silent> <Plug>Firebolt_; :<C-u>call <SID>RepeatFind(";", "v")<CR>
vnoremap <silent> <Plug>Firebolt_, :<C-u>call <SID>RepeatFind(",", "v")<CR>
onoremap <silent> <Plug>Firebolt_; :<C-u>call <SID>RepeatFind(";", "o")<CR>
onoremap <silent> <Plug>Firebolt_, :<C-u>call <SID>RepeatFind(",", "o")<CR>

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

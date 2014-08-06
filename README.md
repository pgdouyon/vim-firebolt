FirebolT
========

FirebolT provides enhanced f/t motions for Vim, replacing the defaults with a
2-character inline search.  In addition FirebolT provides a one-character search
inline search motion specifically for jumping to parentheses, brackets, braces,
and angle brackets.


Usage
-----

By default FirebolT overwrites f,F,t,T,; and , to provide the 2-character search
and reverse.  To use different mappings copy the following line into your vimrc:
`let g:firebolt_no_mappings = 1`

Custom mappings can be specified by remapping the corresponding
`<Plug>Firebolt_*` map where the '\*' corresponds to one of {fFtT;,}.

Firebolt also provides functionality to jump to parentheses, brackets, braces,
or angle brackets using the `gl` or `gL` mappings for forward/backward jumps
respectively.  These mappings uses the same one-char alias as [surround.vim][]
to determine the character to jump to.

| Input | Target |
| ----- | ------ |
| b     | ( or ) |
| B     | { or } |
| r     | [ or ] |
| a     | < or > |

The default mapping can be overridden via the `<Plug>Firebolt_gl` and
`<Plug>Firebolt_gL` mappings.


Installation
------------

* [Pathogen][]
    * `cd ~/.vim/bundle && git clone https://github.com/pgdouyon/vim-firebolt.git`
* [Vundle][]
    * `Plugin 'pgdouyon/vim-firebolt'`
* [NeoBundle][]
    * `NeoBundle 'pgdouyon/vim-firebolt'`
* [Vim-Plug][]
    * `Plug 'pgdouyon/vim-firebolt'`
* Manual Install
    * Copy all the files into the appropriate directory under `~/.vim` on \*nix or
      `$HOME/_vimfiles` on Windows


License
-------

Copyright (c) 2014 Pierre-Guy Douyon.  Distributed under the MIT License.


[surround.vim]: https://github.com/tpope/vim-surround
[Pathogen]: https://github.com/tpope/vim-pathogen
[Vundle]: https://github.com/gmarik/Vundle.vim
[NeoBundle]: https://github.com/Shougo/neobundle.vim
[Vim-Plug]: https://github.com/junegunn/vim-plug

FirebolT
========

FirebolT provides enhanced f/t motions for Vim, replacing the defaults with a
2-character inline search.  In addition FirebolT provides a one-character search
motion to replace f/F.


Usage
-----

By default FirebolT overwrites the set of characters `ftFT;,` to provide the
2-character search and reverse.  To use different mappings copy the following
line into your vimrc:

`let g:firebolt_no_mappings = 1`

Custom mappings can be specified by remapping the corresponding
`<Plug>Firebolt_*` map where the '\*' corresponds to one of `ftFT;,`.

Firebolt also provides a one-character search motion using `r` and `R` for
foward/backward searching, respectively.

The default mapping can be overridden via the `<Plug>Firebolt_r` and
`<Plug>Firebolt_R` mappings.


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

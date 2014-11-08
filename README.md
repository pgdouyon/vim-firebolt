FirebolT
========

FirebolT provides an extra 2-character inline search motion for Vim to augment
the built-in f/t motions.


Usage
-----

By default FirebolT overwrites the characters `r` and `R` to provide the
2-character search and reverse and remaps `s`/`S` to replace the built-in
`r`/`R` functionality.  To use different mappings copy the following line into
your vimrc:

`let g:firebolt_no_mappings = 1`

Custom mappings can be specified by remapping the `<Plug>Firebolt_r` and
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

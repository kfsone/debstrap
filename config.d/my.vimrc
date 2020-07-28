"""" EDITING CONFIG

" For the most part, I operate with spaces in ts=4, I use editorconfig
" and autocmds to enforce tabs for C++, go etc.
"
set autoindent
set backspace=2
set encoding=utf-8
set smartindent
set smarttab
set sw=4
set ts=4

" Enable file-type recognition and syntax highlighting.
"
filetype on
filetype plugin on
filetype indent on
syntax on

" Enable the wild-card menu when trying to find files.
"
set wildmenu

"""" KEY MAPS

" I like '[' mapped to 'next warning/error/grep result', so
" I can skip thru search results or compile errors quickly.
"
nnoremap = :cn<CR>

"""" DISPLAY
set background=dark 

" Limiting stuff to 80 characters makes for easier mobile viewing and
" side-by-side, esp 3-way, compares.
"
set colorcolumn=110

set lazyredraw modeline modelines=1 showtabline=1 laststatus=2

"""" FILE TYPE CONFIG

augroup configgroup
    autocmd!
    " remove trailing spaces
    autocmd FileType c,cpp,python,*.sh,.vimrc,.bashrc,*.xml,shell,html,go,txt,json,yaml,md,powershell,ps1,*.ps1 autocmd BufWritePre <buffer> %s/\s\+$//e

    " tabs vs spaces
    autocmd FileType python,vim,shell                   setlocal ts=4 sw=4 expandtab number colorcolumn=100 colorcolumn=120
    autocmd FileType vim                                setlocal noexpandtab
    autocmd FileType powershell,ps1,*.ps1,pm1,*.pm1     setlocal ts=2 sw=2 expandtab number colorcolumn=100 colorcolumn=120
    autocmd FileType powershell,ps1,*.ps1               setlocal ts=2 sw=2 expandtab number colorcolumn=100 colorcolumn=120
    autocmd FileType c,cpp,java,go                      setlocal ts=4 sw=4 noexpandtab number colorcolumn=100
augroup END

function! GitGrep(...)
    let cmd = "git grep -n --column " . join(a:000, " ")
    set efm=%f:%l:%c:%m
    cexpr system(cmd)
endfunction

command! -nargs=+ Ggrep :call GitGrep(<f-args>)

function! Ninja(...)
	let cmd = "ninja " . join(a:000, " ")
	cexpr system(cmd)
endfunction

command! -nargs=+ Ninja :call Ninja(<f-args>)

let g:flake8_show_in_gutter = 1
let g:flake8_show_in_file = 1

autocmd FileType python map <buffer> <F8> :call Flake8()<CR>


let mapleader = " "

set clipboard+=unnamedplus
set spell
set spelloptions=camel
set tabstop=4 softtabstop=4
set textwidth=80
set shiftwidth=4
set expandtab
set relativenumber
set smartindent
set nu
set nohlsearch
set hidden
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set scrolloff=8
set signcolumn=yes
set colorcolumn=80
set list listchars=tab:>\ ,trail:-,eol:↵
" Attempt to resolve errors with some nvim-cmp + LSP interactions.
set maxmempattern=5000

" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*


nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" Cycle between buffers.
nnoremap L :bn<CR>
nnoremap H :bp<CR>
" Create a new blank file in a new buffer.
nnoremap <C-n> :enew<CR>
" Close a buffer.
nnoremap <leader>q :bdelete<CR>

" delete without copying to register
nnoremap <leader>d "_d
" select all.
nnoremap <C-a> ggVG
xnoremap <leader>d "_d
" paste without popping from register
xnoremap p "_dp
xnoremap P "_dP
" change without copying to register
xnoremap c "_c
" change without copying to register
xnoremap s "_s
" delete without copying to register
xnoremap x "_x
" copy to OS's copy register
vnoremap <leader>y "+y

" Center the cursor after moving up/down.
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
" Center search results.
nnoremap n nzzzv
nnoremap N Nzzzv
" Jump to previous buffer.
nnoremap <leader>pb :b#<CR>
" Use escape to exit terminal insert mode. Note that the current terminal emulator
" should ignore the escape key to prevent 
tnoremap jj <C-\><C-n>


" Overwrite the default behaviour of replacing default register when pasting
" on top of text.
" Source: https://stackoverflow.com/a/290723/15196379
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction

function! s:Repl()
    let s:restore_reg = @"
    return "p@=RestoreRegister()\<cr>"
endfunction

" NB: this supports "rp that replaces the selection by the contents of @r
vnoremap <silent> <expr> p <sid>Repl()


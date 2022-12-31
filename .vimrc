set relativenumber


let mapleader = " "
" set clipboard+=unnamedplus

nnoremap <Leader><CR> :so ~/.config/nvim/init.vim<CR>
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
xnoremap <leader>d "_d
" paste without popping from register
xnoremap <leader>p "_dP
" copy to OS's copy register
vnoremap <leader>y "+y

source ~/sets.vim

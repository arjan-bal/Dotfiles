let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'jiangmiao/auto-pairs'
Plug 'onsails/lspkind.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'folke/tokyonight.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'mfussenegger/nvim-jdtls'
Plug 'numToStr/Comment.nvim'
Plug 'akinsho/bufferline.nvim'
Plug 'lewis6991/gitsigns.nvim'

call plug#end()

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
" find and replace selected text
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

augroup ARJAN
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
augroup END

lua require("config")

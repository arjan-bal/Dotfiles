let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'jiangmiao/auto-pairs'
Plug 'onsails/lspkind.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'mfussenegger/nvim-jdtls'
Plug 'numToStr/Comment.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'navarasu/onedark.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'rafamadriz/friendly-snippets'
Plug 'williamboman/mason.nvim'
Plug 'tpope/vim-fugitive'
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'leoluz/nvim-dap-go'

call plug#end()

source ~/.vimrc
lua require("config")

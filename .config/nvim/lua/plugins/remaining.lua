return {
    {
        'hrsh7th/cmp-buffer',
        lazy = false,
    },
    {
        'hrsh7th/cmp-path',
        lazy = false,
    },
    {
        'hrsh7th/cmp-nvim-lua',
        lazy = false,
    },
    {
        'hrsh7th/cmp-nvim-lsp',
        lazy = false,
    },
    {
        'saadparwaiz1/cmp_luasnip',
        lazy = false,
    },
    {
        'jiangmiao/auto-pairs',
        lazy = false,
    },
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        version = "v1.8.0",
    },
    {
        'kyazdani42/nvim-web-devicons',
        lazy = false,
    },
    {
        'mfussenegger/nvim-jdtls',
        ft = 'java',
    },
    {
        'navarasu/onedark.nvim',
        lazy = false,
    },
    {
        'mason-org/mason.nvim',
        lazy = false,
        opts = {},
    },
    {
        'tpope/vim-fugitive',
        lazy = false,
    },
    {
        'theHamsta/nvim-dap-virtual-text',
        dependencies = {
            'mfussenegger/nvim-dap',
            'nvim-treesitter/nvim-treesitter',
        },
        lazy = true,
    },
}

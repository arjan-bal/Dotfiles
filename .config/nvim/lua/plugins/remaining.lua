return {
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            'saghen/blink.cmp',
        },
    },
    {
        'kyazdani42/nvim-web-devicons',
        lazy = false,
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

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
        -- Workaround commit that mistakenly a introduced breaking change.
        -- Buggy PR: https://github.com/hrsh7th/cmp-nvim-lsp/pull/81
        -- Tracking issue: https://github.com/hrsh7th/cmp-nvim-lsp/issues/85
        branch = 'main',
        commit = 'a8912b88ce488f411177fc8aed358b04dc246d7b',
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

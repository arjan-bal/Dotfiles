return {
    'kyazdani42/nvim-tree.lua',
    lazy = false,
    config = function()
        -- local tree_cb = nvim_tree_config.nvim_tree_callback
        -- disable netrw at the very start of your init.lua
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        local nvim_tree = require('nvim-tree')
        -- following options are the default
        -- each of these are documented in `:help nvim-tree.OPTION_NAME`

        nvim_tree.setup({
            update_cwd = false,
            diagnostics = {
                enable = true,
                icons = {
                    hint = "",
                    info = "",
                    warning = "",
                    error = "",
                },
            },
            update_focused_file = {
                enable = true,
                ignore_list = {},
            },
            git = {
                enable = true,
                ignore = false,
                timeout = 500,
            },
            renderer = {
                group_empty = true,
            },
            view = {
                width = 60,
                side = "right",
                --    mappings = {
                --      custom_only = false,
                --      list = {
                --        { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
                --        { key = "c", cb = tree_cb "close_node" },
                --        { key = "v", cb = tree_cb "vsplit" },
                --        { key = "n", cb = tree_cb "create" },
                --      },
                --    },
                number = true,
                relativenumber = true,
            },
        })

        vim.api.nvim_set_keymap('n', '<leader>pv', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
    end
}

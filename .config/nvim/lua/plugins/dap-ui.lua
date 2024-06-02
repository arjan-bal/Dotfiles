return {
    'rcarriga/nvim-dap-ui',
    lazy = true,
    dependencies = {
        'mfussenegger/nvim-dap',
        'nvim-neotest/nvim-nio',
    },
    keys = {
        -- Keymap to toggle DAP UI with reset
        {
            '<leader>du',
            function()
                local dapui = require("dapui")
                dapui.toggle({ reset = true })
            end,
            desc = 'Toggle DAP UI (with reset)'
        },
    },
    config = function()
        require("dapui").setup()
    end,
}

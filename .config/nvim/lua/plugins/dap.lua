return {
    'mfussenegger/nvim-dap',
    lazy = true,  -- Enable lazy loading
    module = true,
    keys = {
        { '<leader>tb', function() require("dap").toggle_breakpoint() end, desc = 'Toggle Breakpoint' },
        { '<leader>dc', function() require("dap").continue() end, desc = 'Continue' },
        { '<leader>dn', function() require("dap").step_over() end, desc = 'Step Over' },
        { '<leader>di', function() require("dap").step_into() end, desc = 'Step Into' },
        { '<leader>do', function() require("dap").step_out() end, desc = 'Step Out' },
        { '<leader>dx', function() require("dap").terminate() end, desc = 'Terminate' },
    },
    config = function()
        require("lazy").load({ plugins = { 'nvim-dap-virtual-text'} })
    end
}


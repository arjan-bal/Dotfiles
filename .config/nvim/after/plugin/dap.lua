local dap = require("dap")
local dui = require("dapui")
require("nvim-dap-virtual-text").setup()
dui.setup()

-- For delve specific config see https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
require("dap-go").setup {
    -- Additional dap configurations can be added.
    -- dap_configurations accepts a list of tables where each entry
    -- represents a dap configuration. For more details do:
    -- :help dap-configuration
    dap_configurations = {
        {
            -- Must be "go" or it will be ignored by the plugin
            type = "go",
            name = "Debug Test",
            mode = "test",
            request = "launch",
            program = "./${relativeFileDirname}",
        },
    },
}

vim.keymap.set("n", "<leader>tb", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dc", dap.continue)
vim.keymap.set("n", "<leader>dn", dap.step_over)
vim.keymap.set("n", "<leader>di", dap.step_into)
vim.keymap.set("n", "<leader>do", dap.step_out)
vim.keymap.set("n", "<leader>du", dui.toggle)
vim.keymap.set("n", "<leader>dx", dap.terminate)

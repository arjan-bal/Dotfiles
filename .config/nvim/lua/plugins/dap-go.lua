return {
    'leoluz/nvim-dap-go',
    dependencies = {
        'mfussenegger/nvim-dap',
    },
    ft = "go",
    config = function()
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

        -- GoTest starts launches tests that match the pattern in debugging mode.
        function GoTest(test_name)
            require("dap").run({
                type = "go",
                name = test_name,
                request = "launch",
                mode = "test",
                program = "./${relativeFileDirname}",
                args = {
                    "-test.v",
                    "-test.run", test_name,
                    "-test.count", "1",
                },
                env = {
                    GOFLAGS = "-vet=off",
                },
            })
        end

        vim.cmd([[
            command! -nargs=1 GoTest call v:lua.GoTest(<f-args>)
        ]])
    end
}

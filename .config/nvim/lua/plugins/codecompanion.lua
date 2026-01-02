return {
    {
        "olimorris/codecompanion.nvim",
        version = "^18.0.0",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        init = function()
            vim.cmd("cab cc CodeCompanion")
        end,
        lazy = true,
        cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions" },
        keys = {
            { "<C-a>",          "<cmd>CodeCompanionActions<cr>",     mode = { "n", "v" }, desc = "CodeCompanion Actions" },
            { "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle CodeCompanion Chat" },
            { "ga",             "<cmd>CodeCompanionChat Add<cr>",    mode = "v",          desc = "Add selection to CodeCompanion" },
        },
        opts = {
            display = {
                chat = {
                    window = {
                        width = 0.3, ---@return number|fun(): number
                    },
                },
            },
            adapters = {
                acp = {
                    gemini_cli_nightly = function()
                        -- Load the original definition and Deep Copy it
                        -- We deepcopy so we don't accidentally modify the cached module for other instances
                        local adapter = vim.deepcopy(require("codecompanion.adapters.acp.gemini_cli"))

                        -- Remove the auth token env var.
                        adapter.env = nil
                        adapter.defaults.auth_method = nil
                        local gemini_path = vim.env.GEMINI_BIN_PATH or "gemini"

                        -- Update the command to point to your internal binary
                        adapter.commands.default = {
                            gemini_path,
                            "--experimental-acp",
                        }
                        -- Bypass auth.
                        adapter.handlers.auth = function()
                            return true
                        end
                        return require("codecompanion.adapters.acp").new(adapter)
                    end,
                    opts = {
                        show_presets = false,
                    },
                },
                http = {
                    gemini = function()
                        return require("codecompanion.adapters").extend("gemini", {})
                    end,
                    opts = {
                        show_presets = false,
                    },
                },
            },
            interactions = {
                chat = {
                    adapter = "gemini_cli_nightly",
                },
                inline = {
                    adapter = "gemini",
                },
                cmd = {
                    adapter = "gemini_cli_nightly",
                },
            },
        },
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        opts = {},
        ft = { "markdown", "codecompanion" }
    }
}

return {
    {
        "olimorris/codecompanion.nvim",
        version = "^18.0.0",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "j-hui/fidget.nvim",
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
        config = function(_, opts)
            require("codecompanion").setup(opts)

            local progress = require("fidget.progress")
            local handles = {}
            local group = vim.api.nvim_create_augroup("CodeCompanionFidget", {})

            vim.api.nvim_create_autocmd("User", {
                pattern  = "CodeCompanionRequestStarted",
                group    = group,
                callback = function(e)
                    handles[e.data.id] = progress.handle.create({
                        title = "CodeCompanion",
                        message = "Thinking...",
                        lsp_client = { name = e.data.adapter.formatted_name },
                    })
                end
            })

            vim.api.nvim_create_autocmd("User", {
                pattern  = "CodeCompanionRequestFinished",
                group    = group,
                callback = function(e)
                    local h = handles[e.data.id]
                    if not h then return end
                    if e.data.status == "success" then
                        h.message = "Done"
                    else
                        h.message = "Failed"
                    end
                    h:finish()
                    handles[e.data.id] = nil
                end
            })
        end
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
        ---@module 'render-markdown'
        opts = {},
        ft = { "markdown", "codecompanion" }
    }
}

--- Creates an HTTPAdapter that calls a CLI command instead of making HTTP
--- calls.
--- @param config {
---   name: string,
---   formatted_name: string,
---   command: string,
---   get_args: fun(prompt: string): string[] }
--- @return table adapter The constructed CodeCompanion.HTTPAdapter.
local function make_cli_adapter(config)
    return {
        name = config.name,
        formatted_name = config.formatted_name,
        roles = {
            llm = "model",
            user = "user",
        },
        schema = {},
        opts = {
            stream = false,
            request = function(client, payload, actions, opts)
                local utils = require("codecompanion.utils")
                opts.id = opts.id or math.random(10000000)
                opts.adapter = {
                    name = config.name,
                    formatted_name = config.formatted_name,
                    model = "",
                }
                utils.fire("RequestStarted", opts)

                local prompt = ""
                for _, msg in ipairs(payload.messages) do
                    prompt = prompt .. msg.content .. "\n\n"
                end

                local output = {}
                local job = require("plenary.job"):new({
                    command = config.command,
                    args = config.get_args(prompt),
                    writer = "",

                    -- Thread safety: schedule_wrap ensures
                    -- UI actions happen on the main thread
                    on_stdout = vim.schedule_wrap(function(_, data)
                        table.insert(output, data)
                    end),

                    on_stderr = vim.schedule_wrap(function(_, data)
                        actions.callback(data, nil)
                    end),

                    on_exit = vim.schedule_wrap(function(_, return_val)
                        if return_val ~= 0 then
                            actions.callback("Command failed with exit code " .. return_val, nil)
                        else
                            local response_text = table.concat(output, "\n")
                            actions.callback(nil, response_text, client.adapter)
                        end

                        if actions.done then
                            actions.done()
                        end
                        utils.fire("RequestFinished", opts)
                    end),
                })
                job:start()
                return {
                    cancel = function()
                        job:shutdown()
                    end,
                }
            end,
        },
        handlers = {
            response = {
                parse_inline = function(_, data)
                    return { status = "success", output = data }
                end,
            },
        },
    }
end

local has_work, work = pcall(require, "work")

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
                    opts = {
                        show_presets = false,
                    },
                },
                http = {
                    gemini = function()
                        return require("codecompanion.adapters").extend("gemini", {})
                    end,
                    [has_work and work.llm_config.name or "unregistered"] = has_work and function()
                        return make_cli_adapter(work.llm_config)
                    end,
                    opts = {
                        show_presets = false,
                    },
                },
            },
            interactions = {
                chat = {
                    adapter = "gemini",
                },
                inline = {
                    adapter = has_work and work.llm_config.name or "gemini",
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

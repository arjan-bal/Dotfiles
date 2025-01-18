local ok, lspconfig = pcall(require, "lspconfig")
if not ok then
  return
end

local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}
local handlers = require("lsp.handlers")

local opts = {
    capabilities = handlers.capabilities,
    on_attach = handlers.on_attach,
    flags = lsp_flags,
}

-- Config for each language server.
local lua_ls_opts = {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
        },
    },
}

local gopls_opts = {
    on_attach = function(client, bufnr)
        handlers.on_attach(client, bufnr)
    end,
}

local rust_analyzer_opts = {
    settings = {
        ["rust_analyzer"] = {
            diagnostics = {
                styleLints = {
                    enable = true,
                },
            },
            cargo = {
                allFeatures = true,
            },
            check = {
                command = "clippy",
            }
        },
    },
    commands = {
        ExpandMacro = {
            function()
                vim.lsp.buf_request_all(
                    0,
                    "rust-analyzer/expandMacro",
                    vim.lsp.util.make_position_params(),
                    function(responses)
                        if #responses == 0 then
                            vim.notify("No macro expansion available", vim.log.levels.WARN)
                            return
                        end
                        -- Create a floating window to display the content
                        local content = responses[1].result.expansion
                        local buf = vim.api.nvim_create_buf(false, true)
                        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))

                        local width = math.min(80, vim.o.columns - 4)
                        local height = math.min(20, vim.o.lines - 4)
                        local winOpts = {
                            relative = "cursor",
                            width = width,
                            height = height,
                            row = 1,
                            col = 1,
                            style = "minimal",
                            border = "rounded",
                        }
                        vim.api.nvim_open_win(buf, true, winOpts)
                    end)
            end
        }
    }
}

-- Default config for all LSPs.
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require("lsp.handlers").on_attach(client, bufnr)
    end,
})

lspconfig['pyright'].setup(opts)
lspconfig['rust_analyzer'].setup(vim.tbl_deep_extend("force", opts, rust_analyzer_opts))
lspconfig['lua_ls'].setup(vim.tbl_deep_extend("force", lua_ls_opts, opts))
lspconfig['gopls'].setup(vim.tbl_deep_extend("force", opts, gopls_opts))

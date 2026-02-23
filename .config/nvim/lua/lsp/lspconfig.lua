local handlers = require("lsp.handlers")

local opts = {
    capabilities = handlers.capabilities,
    on_attach = handlers.on_attach,
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

local rust_analyzer_opts = {
    settings = {
        ["rust-analyzer"] = {
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
            },
            imports = {
                granularity = {
                    group = "item",
                },
            },
            rustfmt = {
                extraArgs = {
                    "+nightly",
                    "--config",
                    "unstable_features=true,group_imports=StdExternalCrate,imports_granularity=Item",
                },
            },
        },
    },
    commands = {
        ExpandMacro = {
            function()
                local clients = vim.lsp.get_clients({ bufnr = 0, method = "rust-analyzer/expandMacro" })

                local responses = {}
                for _, client in ipairs(clients) do
                    local offset_encoding = client.offset_encoding or "utf-16"
                    local params = vim.lsp.util.make_range_params(0, offset_encoding)
                    local err, res = client:request_sync("rust-analyzer/expandMacro", params, 1000, 0)
                    if not err and res then
                        table.insert(responses, res)
                    end
                end

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
            end
        }
    }
}

local clangd_opts = {
    cmd = { "clangd", "--compile-commands-dir=." },
    root_dir = require("lspconfig/util").root_pattern("compile_commands.json", ".git"),
}

vim.lsp.config('pyright', opts)
vim.lsp.config('rust_analyzer', vim.tbl_deep_extend("force", opts, rust_analyzer_opts))
vim.lsp.config('lua_ls', vim.tbl_deep_extend("force", lua_ls_opts, opts))
vim.lsp.config('gopls', opts)
vim.lsp.config('clangd', vim.tbl_deep_extend("force", opts, clangd_opts))
vim.lsp.config('taplo', opts)
vim.lsp.config('cmake', opts)

vim.lsp.enable('pyright')
vim.lsp.enable('rust_analyzer')
vim.lsp.enable('lua_ls')
vim.lsp.enable('gopls')
vim.lsp.enable('clangd')
vim.lsp.enable('taplo')
vim.lsp.enable('cmake')

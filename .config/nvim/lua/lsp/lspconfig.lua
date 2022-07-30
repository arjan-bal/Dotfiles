local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}

local opts = {
    capabilities = require("lsp.handlers").capabilities,
    on_attach = require("lsp.handlers").on_attach,
    flags = lsp_flags,
}

-- Config for each language server.

local sumneko_opts = {
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

require('lspconfig')['pyright'].setup(opts)
require('lspconfig')['tsserver'].setup(opts)
require('lspconfig')['rust_analyzer'].setup(opts)
require('lspconfig')['sumneko_lua'].setup(vim.tbl_deep_extend("force", sumneko_opts, opts))

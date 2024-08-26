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

-- Default config for all LSPs.
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        require("lsp.handlers").on_attach(client, bufnr)
    end,
})

require('lspconfig')['pyright'].setup(opts)
require('lspconfig')['rust_analyzer'].setup(opts)
require('lspconfig')['lua_ls'].setup(vim.tbl_deep_extend("force", lua_ls_opts, opts))
require('lspconfig')['gopls'].setup(vim.tbl_deep_extend("force", opts, gopls_opts))

local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = vim.tbl_deep_extend(
    'force',
    M.capabilities,
    require('blink.cmp').get_lsp_capabilities({}, false))
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

M.setup = function()
    local config = {
        -- disable virtual text
        virtual_text = false,
        -- show signs
        signs = {
            active = {
                { name = "DiagnosticSignError", text = "" },
                { name = "DiagnosticSignWarn", text = "" },
                { name = "DiagnosticSignHint", text = "" },
                { name = "DiagnosticSignInfo", text = "" },
            },
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN]  = "",
                [vim.diagnostic.severity.INFO]  = "",
                [vim.diagnostic.severity.HINT]  = "",
            },
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            source = "always",
            header = "",
            prefix = "",
        },
    }
    vim.diagnostic.config(config)
end

local function lsp_highlight_document(client, bufnr)
    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Document Highlight",
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Clear All the References",
        })
    end
end

local function lsp_keymaps(bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover({ border = "rounded" })
    end, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gl", vim.diagnostic.open_float, bufopts)
    vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
    end, bufopts)
    vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
    end, bufopts)
    vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, bufopts)
    vim.keymap.set('n', '<C-k>', function()
        vim.lsp.buf.signature_help({ border = "rounded" })
    end, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, bufopts)
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local format_group_name = "FormatOnSave"
local format_group = vim.api.nvim_create_augroup(format_group_name, { clear = true })

local function enable_format_on_save()
    vim.api.nvim_create_autocmd('BufWritePre', {
        group = format_group,
        callback = function()
            vim.lsp.buf.format({ async = false })
        end,
        vim.notify "Enabled format on save"
    })
end



local function toggle_format_on_save()
    local autocommands = vim.api.nvim_get_autocmds({
        group = format_group_name,
    })

    if next(autocommands) == nil then
        enable_format_on_save()
    else
        vim.api.nvim_clear_autocmds({
            group = format_group_name
        })
        vim.notify "Disabled format on save"
    end
end

vim.api.nvim_create_user_command('LspToggleAutoFormat', function()
    toggle_format_on_save()
end, {})

M.on_attach = function(client, bufnr)
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    lsp_keymaps(bufnr)
    lsp_highlight_document(client, bufnr)
    if client.supports_method('textDocument/formatting') then
        enable_format_on_save()
    end
end

return M

M = {}

M.setup = function()
    require("lsp.handlers").setup()
    require("lsp.lspconfig")
end

return M

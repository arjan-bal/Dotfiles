return {
    'nvimtools/none-ls.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    lazy = false,
    config = function()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.buf,
                null_ls.builtins.diagnostics.buf,
                null_ls.builtins.diagnostics.revive,
            }
        })
    end
}

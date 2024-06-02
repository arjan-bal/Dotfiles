local ok_lsp, _ = pcall(require, "lsp.handlers")
if ok_lsp then
    require("lsp.handlers").enable_format_on_save()
end


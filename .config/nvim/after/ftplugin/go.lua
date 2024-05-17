local status_ok, _ = pcall(require, "lsp.handlers")
if not status_ok then
    return
end

require("lsp.handlers").toggle_format_on_save()

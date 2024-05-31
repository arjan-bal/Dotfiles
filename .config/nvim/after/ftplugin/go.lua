local ok_lsp, _ = pcall(require, "lsp.handlers")
if ok_lsp then
    require("lsp.handlers").toggle_format_on_save()
end

local ok_dap, dap = pcall(require, "dap")
if not ok_dap then
    return
end

-- GoTest starts launches tests that match the pattern in debugging mode.
function GoTest(test_name)
    dap.run({
        type = "go",
        name = test_name,
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}",
        args = {
            "-test.v",
            "-test.run", test_name,
            "-test.count=1"
        }
    })
end

vim.cmd([[
    command! -nargs=1 GoTest call v:lua.GoTest(<f-args>)
]])

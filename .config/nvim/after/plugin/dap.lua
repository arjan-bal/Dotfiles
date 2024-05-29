local dap = require("dap")
local dui = require("dapui")
require("nvim-dap-virtual-text").setup()
dui.setup()
require("dap-go").setup()

vim.keymap.set("n", "<leader>tb", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>dc", dap.continue)
vim.keymap.set("n", "<leader>dn", dap.step_over)
vim.keymap.set("n", "<leader>di", dap.step_into)
vim.keymap.set("n", "<leader>do", dap.step_out)
vim.keymap.set("n", "<leader>du", dui.toggle)
vim.keymap.set("n", "<leader>dx", dap.terminate)


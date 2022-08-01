-- Taken from @tjdevries
local ls = require "luasnip"
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

require("luasnip.loaders.from_vscode").lazy_load()

ls.config.set_config {
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  history = true,

  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  updateevents = "TextChanged,TextChangedI",

  -- Autosnippets:
  enable_autosnippets = true,

  -- Crazy highlights!!
  -- #vid3
  -- ext_opts = nil,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " <- Current Choice", "NonTest" } },
      },
    },
  },
}

local rust_cp = {
    "/*",
    "    Author: Arjan Singh Bal",
    "    \"Everything in this world is magic, except to the magician\"",
    "*/",
    "",
    "#[allow(unused_imports)]",
    "use std::str::FromStr;",
    "use std::io::{BufWriter, stdin, stdout, Write, Stdout};",
    "",
    "#[derive(Default)]",
    "struct Scanner {",
    "    buffer: Vec<String>",
    "}",
    "",
    "impl Scanner {",
    "    fn next<T: std::str::FromStr>(&mut self) -> T {",
    "        loop {",
    "            if let Some(token) = self.buffer.pop() {",
    "                return token.parse().ok().expect(\"Failed parse\");",
    "            }",
    "            let mut input = String::new();",
    "            stdin().read_line(&mut input).expect(\"Failed read\");",
    "            self.buffer = input.split_whitespace().rev().map(String::from).collect();",
    "        }",
    "    }",
    "}",
    "",
    "fn main() {",
    "    let mut scan = Scanner::default();",
    "    let mut out = &mut BufWriter::new(stdout());",
    "    let t = scan.next();",
    "    for _ in 0..t {",
    "        solve(&mut scan, &mut out);",
    "    }",
    "}",
    "",
    "fn solve(scan: &mut Scanner, out: &mut BufWriter<Stdout>) {",
    "    $1",
    "}",
    "",
}

ls.add_snippets("rust", {
        -- Available in any file type
        ls.parser.parse_snippet(
        "rust_cp",
        table.concat(rust_cp, "\n")),
})

-- <c-k> is my expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<C-k>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set("i", "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set("i", "<c-u>", require "luasnip.extras.select_choice")

-- shorcut to source my luasnips file again, which will reload my snippets
vim.keymap.set("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/after/plugin/luasnip.lua<CR>")


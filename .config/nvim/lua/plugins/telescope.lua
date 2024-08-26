return {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    keys = {
        { '<leader>ff',  function() require('telescope.builtin').find_files() end,                desc = 'Find Files' },
        { '<leader>fg',  function() require('telescope.builtin').live_grep() end,                 desc = 'Live Grep' },
        { '<leader>fb',  function() require('telescope.builtin').buffers() end,                   desc = 'Buffers' },
        { '<leader>fh',  function() require('telescope.builtin').help_tags() end,                 desc = 'Help Tags' },
        { '<leader>fo',  function() require('telescope.builtin').lsp_document_symbols() end,      desc = 'Document Symbols' },
        { '<leader>fc',  function() require('telescope.builtin').commands() end,                  desc = 'Commands' },
        { '<leader>fz',  function() require('telescope.builtin').current_buffer_fuzzy_find() end, desc = 'Fuzzy Find in Buffer' },
        { '<leader>fgb', function() require('telescope.builtin').git_branches() end,              desc = 'Git Branch' },
    },
    opts = function()
        return {
            defaults = {
                mappings = {
                    n = {
                        ['dd'] = require('telescope.actions').delete_buffer,
                    },
                },
            },
        }
    end,
}

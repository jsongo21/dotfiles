return {
    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- Fuzzy Finder Algorithm which requires local dependencies to be built.
            -- Only load if `make` is available. Make sure you have the system
            -- requirements installed.
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                -- NOTE: If you are having trouble with this installation,
                --       refer to the README for telescope-fzf-native for more instructions.
                build = 'make',
                cond = function() return vim.fn.executable('make') == 1 end,
            },
        },
        config = function()
            local telescope = require('telescope')

            telescope.setup({
                pickers = {
                    live_grep = {
                        additional_args = function(opts) return { '--hidden' } end,
                    },
                },
            })

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
            vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = '[G]it [F]iles' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
            vim.keymap.set('n', '<leader>fs', builtin.grep_string, { desc = '[F]ind [S]tring' })
            vim.keymap.set(
                'n',
                '<leader>gs',
                builtin.live_grep,
                { desc = '[G]rep [S]tring', noremap = true }
            )
        end,
    },
}

return {
    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-live-grep-args.nvim',
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
            local lga_actions = require('telescope-live-grep-args.actions')

            telescope.setup({
                defaults = {
                    file_ignore_patterns = { 'node_modules', 'yarn.lock', 'package-lock.json' },
                },
                pickers = {
                    find_files = {
                        theme = 'ivy',
                        hidden = true,
                    },
                    git_files = {
                        theme = 'ivy',
                    },
                    live_grep = {
                        theme = 'ivy',
                        live_grep = {
                            additional_args = function(opts) return { '--hidden' } end,
                        },
                    },
                    grep_string = {
                        theme = 'ivy',
                    },
                },
                extensions = {
                    live_grep_args = {
                        mappings = {
                            i = {
                                ['<C-k>'] = lga_actions.quote_prompt(),
                                ['<C-i>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
                                -- freeze the current list and start a fuzzy search in the frozen list
                                ['<C-space>'] = lga_actions.to_fuzzy_refine,
                            },
                        },
                    },
                },
            })
            telescope.load_extension('live_grep_args')

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

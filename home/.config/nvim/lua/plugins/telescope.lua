return {
    -- Fuzzy Finder (files, lsp, etc)
    {
        'nvim-telescope/telescope.nvim',
        branch = 'master',
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
                    preview = { treesitter = false },
                    file_ignore_patterns = { 'node_modules', 'yarn.lock', 'package-lock.json' },
                    dynamic_preview_title = true,
                    path_display = { 'filename_first' },
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
                    lsp_references = {
                        theme = 'ivy',
                        fname_width = 100,
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

            -- Neovim 0.12: status table uses __mode="kv" (weak values), so layout
            -- can be GC'd between the guard check and preview_fn execution. Pinning
            -- layout as a strong local prevents collection during the call.
            local Picker = require('telescope.pickers')._Picker
            local ts_state = require('telescope.state')
            local orig_refresh = Picker.refresh_previewer
            Picker.refresh_previewer = function(self)
                local status = ts_state.get_status(self.prompt_bufnr)
                local _layout = status.layout
                if not _layout then return end
                orig_refresh(self)
            end

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

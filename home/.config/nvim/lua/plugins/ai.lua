return {
    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
            require('copilot').setup({
                panel = {
                    enabled = true,
                },
                suggestion = {
                    enabled = true,
                },
            })
        end,
    },
    {
        'olimorris/codecompanion.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {
            strategies = {
                -- Change the default chat adapter
                chat = {
                    adapter = 'copilot',
                },
            },
            opts = {
                -- Set debug logging
                log_level = 'DEBUG',
            },
        },
        keys = {
            -- Add a keybinding to toggle the chat
            {
                '<leader>cc',
                '<cmd>CodeCompanionChat Toggle<cr>',
                mode = 'n',
                desc = 'Toggle Chat',
            },
        },
    },
}

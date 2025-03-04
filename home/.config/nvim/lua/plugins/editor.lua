return {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    -- Time tracking
    'wakatime/vim-wakatime',

    {
        -- Add indentation guides even on blank lines
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        main = 'ibl',
        opts = {},
    },
    {
        'folke/todo-comments.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    {
        'echasnovski/mini.indentscope',
        name = 'mini.indentscope',
        event = 'VeryLazy',
        config = function()
            require('mini.indentscope').setup({
                draw = {
                    delay = 40,
                    priority = 20,
                    animation = require('mini.indentscope').gen_animation.exponential({
                        easing = 'in-out',
                        duration = 80,
                        unit = 'total',
                    }),
                },
                symbol = '┃',
                options = {
                    try_as_border = true,
                },
                mappings = {
                    goto_top = '',
                    goto_bottom = '',
                    object_scope = '',
                    object_scope_with_border = '',
                },
            })

            local disabled = {
                'harpoon',
                'help',
                'terminal',
            }

            vim.api.nvim_create_autocmd('FileType', {
                pattern = '*',
                callback = function()
                    if disabled[vim.bo.filetype] ~= nil or vim.bo.buftype ~= '' then
                        vim.b.miniindentscope_disable = true
                    end
                end,
            })

            vim.cmd([[highlight! link MiniIndentscopeSymbol Identifier]])
        end,
    },

    -- Auto Pairs
    {
        'echasnovski/mini.pairs',
        config = function() require('mini.pairs').setup({}) end,
    },
    {
        'windwp/nvim-ts-autotag',
        config = function() require('nvim-ts-autotag').setup({}) end,
    },

    -- "gc" to comment visual regions/lines
    {
        'echasnovski/mini.comment',
        dependencies = {
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
        opts = {
            hooks = {
                pre = function()
                    require('ts_context_commentstring.internal').update_commentstring()
                end,
            },
        },
    },

    -- Vim Surround
    {
        'kylechui/nvim-surround',
        config = function() require('nvim-surround').setup({}) end,
    },

    --- Markdown Preview
    {
        'toppair/peek.nvim',
        event = { 'VeryLazy' },
        build = 'deno task --quiet build:fast',
        config = function()
            require('peek').setup()

            vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
            vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})

            vim.keymap.set('n', '<leader>po', require('peek').open, { desc = 'Open Peek Preview' })
            vim.keymap.set('n', '<leader>pq', require('peek').open, { desc = 'Close Peek Preview' })
        end,
    },

    --- CSS Colours
    {
        'brenoprata10/nvim-highlight-colors',
        config = function()
            require('nvim-highlight-colors').setup()
        end
    }
}

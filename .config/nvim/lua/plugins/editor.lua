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
        'windwp/nvim-autopairs',
        config = function() require('nvim-autopairs').setup({}) end,
    },
    {
        'windwp/nvim-ts-autotag',
        config = function() require('nvim-ts-autotag').setup({}) end,
    },

    -- "gc" to comment visual regions/lines
    {
        'numToStr/Comment.nvim',
        dependencies = {
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
        config = function()
            require('Comment').setup({
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            })
        end,
    },

    -- Vim Surround
    {
        'kylechui/nvim-surround',
        config = function() require('nvim-surround').setup({}) end,
    },
}

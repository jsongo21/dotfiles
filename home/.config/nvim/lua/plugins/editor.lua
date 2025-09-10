return {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',

    -- Time tracking
    'wakatime/vim-wakatime',

    -- TODO comments
    {
        'folke/todo-comments.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
    },

    -- Highlight Patterns - Hex
    {
        'echasnovski/mini.hipatterns',
        version = '*',
        config = function()
            local hipatterns = require('mini.hipatterns')
            hipatterns.setup({
                tailwind = {
                    enabled = true,
                },
                highlighters = {
                    -- Highlight hex color strings (`#rrggbb`) using that color
                    shorthand = {
                        pattern = '()#%x%x%x()%f[^%x%w]',
                        group = function(_, _, data)
                            ---@type string
                            local match = data.full_match
                            local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
                            local hex_color = '#' .. r .. r .. g .. g .. b .. b

                            return hipatterns.compute_hex_color_group(hex_color, 'bg')
                        end,
                        extmark_opts = { priority = 2000 },
                    },
                },
            })
        end,
    },

    -- Add indentation guides even on blank lines
    {
        'lukas-reineke/indent-blankline.nvim',
        -- Enable `lukas-reineke/indent-blankline.nvim`
        -- See `:help ibl`
        main = 'ibl',
    },

    -- Highlights the indent guide
    {
        'echasnovski/mini.indentscope',
        version = '*',
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
                    try_as_border = false,
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
        version = '*',
        config = function() require('mini.pairs').setup({}) end,
    },

    -- TS auto closing tags
    {
        'windwp/nvim-ts-autotag',
        config = function() require('nvim-ts-autotag').setup({}) end,
    },

    -- "gc" to comment visual regions/lines
    {
        'echasnovski/mini.comment',
        version = '*',
        dependencies = {
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
        opts = {
            options = {
                custom_commentstring = function()
                    require('ts_context_commentstring').setup({
                        enable_autocmd = false,
                    })
                    return require('ts_context_commentstring').calculate_commentstring()
                        or vim.bo.commentstring
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

    --- Pretty Markdown
    {
        'MeanderingProgrammer/render-markdown.nvim', -- Make Markdown buffers look beautiful
        ft = { 'markdown', 'codecompanion' },
        opts = {
            render_modes = true, -- Render in ALL modes
            sign = {
                enabled = false, -- Turn off in the status column
            },
        },
    },

    --- Splitjoin
    {
        'nvim-mini/mini.splitjoin',
        version = false,
        config = function() require('mini.splitjoin').setup() end,
    },
}

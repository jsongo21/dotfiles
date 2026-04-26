vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        if ev.data.spec.name == 'peek.nvim' then
            if not ev.data.active then vim.cmd.packadd('peek.nvim') end
            vim.fn.jobstart('deno task --quiet build:fast', { cwd = ev.data.path })
        end
    end,
})

vim.pack.add({
    { src = 'https://github.com/tpope/vim-sleuth' },
    { src = 'https://github.com/wakatime/vim-wakatime' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/folke/todo-comments.nvim' },
    { src = 'https://github.com/echasnovski/mini.hipatterns', version = vim.version.range('*') },
    { src = 'https://github.com/lukas-reineke/indent-blankline.nvim' },
    { src = 'https://github.com/echasnovski/mini.indentscope', version = vim.version.range('*') },
    { src = 'https://github.com/echasnovski/mini.pairs', version = vim.version.range('*') },
    { src = 'https://github.com/windwp/nvim-ts-autotag' },
    { src = 'https://github.com/JoosepAlviste/nvim-ts-context-commentstring' },
    { src = 'https://github.com/echasnovski/mini.comment', version = vim.version.range('*') },
    { src = 'https://github.com/kylechui/nvim-surround' },
    { src = 'https://github.com/toppair/peek.nvim' },
    { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim' },
    { src = 'https://github.com/nvim-mini/mini.splitjoin' },
})

require('todo-comments').setup({})

local hipatterns = require('mini.hipatterns')
hipatterns.setup({
    tailwind = { enabled = true },
    highlighters = {
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

require('ibl').setup()

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
    options = { try_as_border = false },
})

local disabled_indentscope = { harpoon = true, help = true, terminal = true }
vim.api.nvim_create_autocmd('FileType', {
    pattern = '*',
    callback = function()
        if disabled_indentscope[vim.bo.filetype] ~= nil or vim.bo.buftype ~= '' then
            vim.b.miniindentscope_disable = true
        end
    end,
})
vim.cmd([[highlight! link MiniIndentscopeSymbol Identifier]])

require('mini.pairs').setup({})

require('nvim-ts-autotag').setup({})

require('mini.comment').setup({
    options = {
        custom_commentstring = function()
            require('ts_context_commentstring').setup({ enable_autocmd = false })
            return require('ts_context_commentstring').calculate_commentstring()
                or vim.bo.commentstring
        end,
    },
})

require('nvim-surround').setup({})

require('peek').setup()
vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})
vim.keymap.set('n', '<leader>po', require('peek').open, { desc = 'Open Peek Preview' })
vim.keymap.set('n', '<leader>pq', require('peek').open, { desc = 'Close Peek Preview' })

require('render-markdown').setup({
    render_modes = true,
    sign = { enabled = false },
})

require('mini.splitjoin').setup()

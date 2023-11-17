return {
    -- Gruvbox
    {
        'ellisonleao/gruvbox.nvim',
        priority = 1000,
        config = function()
            require('gruvbox').setup()
            vim.o.background = 'dark'
            vim.cmd('colorscheme gruvbox')
        end,
    },

    -- -- Rose Pine
    -- {
    --     'rose-pine/neovim',
    --     name = 'rose-pine',
    --     config = function()
    --         require('rose-pine').setup({
    --             variant = 'auto',
    --         })
    --         vim.o.background = 'dark'
    --         vim.cmd('colorscheme rose-pine')
    --     end,
    -- },

    -- -- Kanagawa
    -- {
    --     'rebelot/kanagawa.nvim',
    --     priority = 1000,
    --     config = function()
    --         require('kanagawa').setup()
    --         vim.api.nvim_create_autocmd('ColorScheme', {
    --             pattern = 'kanagawa',
    --             callback = function()
    --                 if vim.o.background == 'light' then
    --                     vim.fn.system('kitty +kitten themes Kanagawa_light')
    --                 elseif vim.o.background == 'dark' then
    --                     vim.fn.system('kitty +kitten themes Kanagawa_dragon')
    --                 else
    --                     vim.fn.system('kitty +kitten themes Kanagawa')
    --                 end
    --             end,
    --         })
    --     end,
    -- },

    -- -- Tokyo Night
    -- {
    --     'folke/tokyonight.nvim',
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    --     config = function()
    --         require('tokyonight').setup({
    --             -- storm, moon, night, day
    --             style = 'storm',
    --         })
    --
    --         vim.o.background = 'dark'
    --         vim.cmd('colorscheme tokyonight')
    --     end,
    -- },
}

vim.pack.add({
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
})

require('lualine').setup({
    options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
    },
    sections = {
        lualine_c = {
            {
                'filename',
                file_status = true,
                path = 2,
            },
        },
    },
})

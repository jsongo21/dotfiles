return {
    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        build = ':TSUpdate',
        config = function()
            local configs = require('nvim-treesitter.configs')
            ---@diagnostic disable-next-line: missing-fields
            configs.setup({
                auto_install = true,
                ensure_installed = {
                    'bash',
                    'c',
                    'diff',
                    'html',
                    'javascript',
                    'jsdoc',
                    'json',
                    'jsonc',
                    'lua',
                    'luadoc',
                    'luap',
                    'markdown',
                    'markdown_inline',
                    'python',
                    'regex',
                    'tsx',
                    'typescript',
                    'vim',
                    'vimdoc',
                    'yaml',
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                ignore_install = {},
                sync_install = false,
            })
        end,
    },
}

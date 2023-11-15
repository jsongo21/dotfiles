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
            configs.setup({
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
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
            })
        end,
    },
}

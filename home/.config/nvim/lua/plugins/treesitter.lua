return {
    {
        -- Highlight, edit, and navigate code
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter').setup({
                auto_install = true,
                ensure_installed = {
                    'bash',
                    'c',
                    'c_sharp',
                    'css',
                    'diff',
                    'dockerfile',
                    'editorconfig',
                    'graphql',
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
                    'sql',
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

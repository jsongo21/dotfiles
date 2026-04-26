vim.pack.add({
    { src = 'https://github.com/folke/tokyonight.nvim' },
})

require('tokyonight').setup({
    style = 'storm',
    on_highlights = function(highlights, colors)
        highlights.LineNr = { fg = colors.orange }
        highlights.LineNrAbove = { fg = colors.none }
        highlights.LineNrBelow = { fg = colors.none }
    end,
})

vim.o.background = 'dark'
vim.cmd('colorscheme tokyonight')

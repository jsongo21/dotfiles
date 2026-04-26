vim.pack.add({
    { src = 'https://github.com/cbochs/grapple.nvim' },
})

require('grapple').setup({
    scope = 'git',
    icons = true,
    status = false,
})

vim.keymap.set('n', '<leader>a', '<cmd>Grapple toggle<cr>', { desc = 'Tag a file' })
vim.keymap.set('n', '<c-e>', '<cmd>Grapple toggle_tags<cr>', { desc = 'Toggle tags menu' })
vim.keymap.set('n', '<leader>n', '<cmd>Grapple cycle_tags next<cr>', { desc = 'Go to next tag' })
vim.keymap.set('n', '<leader>p', '<cmd>Grapple cycle_tags prev<cr>', { desc = 'Go to previous tag' })

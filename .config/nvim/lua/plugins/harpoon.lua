return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    config = function()
        local harpoon = require('harpoon')
        ---@diagnostic disable-next-line: missing-parameter
        harpoon:setup()

        vim.keymap.set('n', '<leader>a', function() harpoon:list():append() end)
        vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        vim.keymap.set("n", "<C-t>", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)
    end,
}

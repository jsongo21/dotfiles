return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    config = function()
        local harpoon = require('harpoon')
        ---@diagnostic disable-next-line: missing-parameter
        harpoon:setup({
            settings = {
                sync_on_ui_close = true,
                save_on_toggle = true,
            },
        })

        vim.keymap.set(
            'n',
            '<leader>a',
            function() harpoon:list():add() end,
            { desc = '[A]dd a Harpoon mark' }
        )
        vim.keymap.set(
            'n',
            '<C-e>',
            function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = 'List Harpoon Marks' }
        )
        vim.keymap.set(
            'n',
            '<C-t>',
            function() harpoon:list():prev() end,
            { desc = 'Previous Harpoon Mark' }
        )
        vim.keymap.set(
            'n',
            '<C-n>',
            function() harpoon:list():next() end,
            { desc = 'Next Harpoon Mark' }
        )
    end,
}

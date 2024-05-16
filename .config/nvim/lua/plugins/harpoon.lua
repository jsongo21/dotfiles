return {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    config = function()
        local harpoon = require('harpoon')
        ---@diagnostic disable-next-line: missing-parameter
        harpoon:setup({
            settings = {
                sync_on_ui_close = true,
                save_on_toggle = true
            }
        })

        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end

            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder       = require("telescope.finders").new_table({
                    results = file_paths,
                }),
                previewer    = conf.file_previewer({}),
                sorter       = conf.generic_sorter({})
            }):find()
        end

        vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end)
        vim.keymap.set('n', '<C-e>', function() toggle_telescope(harpoon:list()) end, { desc = "Open harpoon window" })
        vim.keymap.set("n", "<C-t>", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)
    end,
}

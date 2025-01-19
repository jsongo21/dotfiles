return {
    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        config = function()
            require('copilot').setup({
                panel = {
                    enabled = true,
                },
                suggestion = {
                    enabled = true,
                },
            })
        end,
    },
    -- {
    --     'zbirenbaum/copilot-cmp',
    --     event = { 'InsertEnter', 'LspAttach' },
    --     fix_pairs = true,
    --     config = function() require('copilot_cmp').setup() end,
    -- },
}

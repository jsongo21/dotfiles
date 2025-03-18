return {
    'cbochs/grapple.nvim',
    opts = {
        scope = 'git', -- also try out "git_branch"
        icons = true, -- setting to "true" requires "nvim-web-devicons"
        status = false,
    },
    keys = {
        { '<leader>a', '<cmd>Grapple toggle<cr>', desc = 'Tag a file' },
        { '<c-e>', '<cmd>Grapple toggle_tags<cr>', desc = 'Toggle tags menu' },

        { '<leader>n', '<cmd>Grapple cycle_tags next<cr>', desc = 'Go to next tag' },
        { '<leader>p', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Go to previous tag' },
    },
}

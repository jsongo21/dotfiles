return {
    -- Git related plugins
    'tpope/vim-rhubarb',
    {
        'tpope/vim-fugitive',
        config = function() vim.keymap.set('n', '<leader>gst', vim.cmd.Git) end,
    },
    {
        -- Adds git related signs to the gutter, as well as utilities for managing changes
        'lewis6991/gitsigns.nvim',
        opts = {
            -- See `:help gitsigns.txt`
            signs = {
                add = { text = '+' },
                change = { text = '~' },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end
                vim.keymap.set(
                    'n',
                    '<leader>hp',
                    require('gitsigns').preview_hunk,
                    { buffer = bufnr, desc = 'Preview git hunk' }
                )

                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then return ']c' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, { expr = true, desc = 'Jump to Next Hunk' })

                map('n', '[c', function()
                    if vim.wo.diff then return '[c' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, { expr = true, desc = 'Jump to Previous Hunk' })

                -- Actions
                map('n', '<leader>hs', gs.stage_hunk, { desc = '[H]unk [S]tage' })
                map('n', '<leader>hr', gs.reset_hunk, { desc = '[H]unk [R]eset' })
                map(
                    'v',
                    '<leader>hs',
                    function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
                    { desc = '[H]unk [S]tage' }
                )
                map(
                    'v',
                    '<leader>hr',
                    function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
                    { desc = '[H]unk [R]eset' }
                )
                map('n', '<leader>hS', gs.stage_buffer, { desc = '[H]unk [S]tage Buffer' })
                map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[H]unk Stage [U]ndo' })
                map('n', '<leader>hR', gs.reset_buffer, { desc = '[H]unk [R]eset Buffer' })
                map('n', '<leader>hp', gs.preview_hunk, { desc = '[H]unk [P]review' })
                map(
                    'n',
                    '<leader>hb',
                    function() gs.blame_line({ full = true }) end,
                    { desc = '[H]unk [B]lame' }
                )
                map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = '[T]oggle [B]lame' })
                map('n', '<leader>hd', gs.diffthis, { desc = '[H]unk [D]iff' })
                map(
                    'n',
                    '<leader>hD',
                    function() gs.diffthis('~') end,
                    { desc = '[H]unk [D]iff [D]elete' }
                )
                map('n', '<leader>td', gs.toggle_deleted, { desc = '[T]oggle [D]eleted' })

                -- Text object
                map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
            end,
        },
    },
}

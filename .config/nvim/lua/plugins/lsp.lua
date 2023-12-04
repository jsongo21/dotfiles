return {
    -- NOTE: This is where your plugins related to LSP can be installed.
    --  The configuration is done below. Search for lspconfig to find it below.
    {
        'williamboman/mason.nvim',
        cmd = 'Mason',
        keys = { { '<leader>cm', '<cmd>Mason<cr>', desc = 'Mason' } },
        build = ':MasonUpdate',
        opts = {
            ensure_installed = {
                'black',
                'stylua',
                'shfmt',
            },
        },
        config = function(_, opts)
            require('mason').setup(opts)
            local mr = require('mason-registry')
            mr:on('package:install:success', function()
                vim.defer_fn(function()
                    -- trigger FileType event to possibly load this newly installed LSP server
                    require('lazy.core.handler.event').trigger({
                        event = 'FileType',
                        buf = vim.api.nvim_get_current_buf(),
                    })
                end, 100)
            end)
            local function ensure_installed()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then p:install() end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },
    {
        'williamboman/mason-lspconfig.nvim',
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'eslint',
                    'gopls',
                    'html',
                    'jsonls',
                    'lua_ls',
                    'pyright',
                    'tailwindcss',
                    'tsserver',
                    'vimls',
                    'yamlls',
                },
                automatic_installation = true,
            })
        end,
    },
    {
        -- LSP Configuration & Plugins
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
            { 'j-hui/fidget.nvim', opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
        config = function()
            local lspconfig = require('lspconfig')
            local lsp_defaults = lspconfig.util.default_config

            lsp_defaults.capabilities =
                require('cmp_nvim_lsp').default_capabilities(lsp_defaults.capabilities) -- additional capabilities from completions

            -- Lua
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' },
                        },
                    },
                },
            })

            -- Go
            lspconfig.gopls.setup({})

            -- Python
            lspconfig.pyright.setup({})

            -- Rust
            lspconfig.rust_analyzer.setup({
                -- Server-specific settings. See `:help lspconfig-setup`
                settings = {
                    ['rust-analyzer'] = {},
                },
            })

            -- JS/TS
            lspconfig.eslint.setup({
                settintgs = {
                    autoFixOnSave = true,
                },
                on_attach = function(client, bufnr)
                    local format_group = 'EslintFormat'
                    -- need to set this
                    -- Sometimes eslint doesn't register this capabilities.
                    client.server_capabilities.documentFormattingProvider = true
                    vim.notify('attaching eslint lsp', vim.log.levels.INFO)

                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = vim.api.nvim_create_augroup(format_group, { clear = true }),
                        buffer = bufnr,
                        command = 'EslintFixAll',
                    })
                end,
            })
            lspconfig.tailwindcss.setup({})
            lspconfig.tsserver.setup({})

            -- Global mappings.
            -- See `:help vim.diagnostic.*` for documentation on any of the below functions

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local opts = { buffer = ev.buf }

                    -- In this case, we create a function that lets us more easily define mappings specific
                    -- for LSP related items. It sets the mode, buffer and description for us each time.
                    local nmap = function(keys, func, desc)
                        if desc then desc = 'LSP: ' .. desc end

                        vim.keymap.set(
                            'n',
                            keys,
                            func,
                            { buffer = ev.buf, desc = desc, remap = false }
                        )
                    end

                    -- Go to definitions and references
                    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
                    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
                    nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
                    nmap('gt', vim.lsp.buf.type_definition, '[G]oto [T]ype Definition')
                    nmap('K', vim.lsp.buf.hover, 'Hover definition')
                    nmap('<leader>rn', vim.lsp.buf.rename, '[R]ename [S]ymbol')
                    nmap(
                        '<leader>ws',
                        require('telescope.builtin').lsp_dynamic_workspace_symbols,
                        '[W]orkspace [S]ymbol'
                    )
                    nmap(
                        '<leader>ds',
                        require('telescope.builtin').lsp_document_symbols,
                        '[D]ocument [S]ymbol'
                    )
                    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)

                    -- Errors inspection
                    nmap('<leader>vd', vim.diagnostic.open_float, 'Open [F]loat')
                    nmap('[d', vim.diagnostic.goto_next, 'Goto [N]ext')
                    nmap(']d', vim.diagnostic.goto_prev, 'Goto [P]rev')
                    nmap('<leader>vl', '<cmd>Telescope diagnostics<cr>', '[L]ist')

                    -- Restart server
                    nmap('<leader>rs', '<cmd>LspRestart<CR>', '[R]estart [S]erver')
                    -- Formatting
                    nmap('<leader>fm', function()
                        vim.lsp.buf.format({ async = true })
                        print('formatted')
                    end, '[F]ormat')
                end,
            })
        end,
    },
    {

        -- Autocompletion
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
            'benfowler/telescope-luasnip.nvim',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
        },
        event = { 'CmdlineEnter', 'InsertEnter' },
        config = function()
            local cmp = require('cmp')
            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            vim.tbl_map(
                function(type) require('luasnip.loaders.from_' .. type).lazy_load() end,
                { 'vscode', 'snipmate', 'lua' }
            )
            local luasnip = require('luasnip')
            require('luasnip').filetype_extend('lua', { 'luadoc' })
            require('luasnip').filetype_extend('python', { 'pydoc' })

            -- keybinds
            local cmp_mappings = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                        return
                    end
                    fallback()
                end, { 'i', 'c' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                        return
                    end
                    fallback()
                end, { 'i', 'c' }),
                -- jump to next snippet placeholder
                ['<C-k>'] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<C-j>'] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            })

            vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

            cmp.setup({
                -- Snippet engine is required for completions
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp_mappings,
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                -- Sources tell the snippet engine where to get suggestions from
                -- The ordering here is used to sort into final list
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                    { name = 'buffer' },
                    { name = 'nvim_lua' },
                    { name = 'path' },
                    { name = 'nvim_lsp_signature_help' }, -- For function signature help
                }),
            })
        end,
    },
    {
        'stevearc/conform.nvim',
        event = 'VeryLazy',
        config = function()
            require('conform').setup({
                formatters_by_ft = {
                    javascript = { { 'eslint' } },
                    lua = { 'stylua' },
                    python = { 'isort', 'black' },
                    go = { "gopls" }
                },
                formatters = {
                    python = {
                        require_cwd = false,
                    },
                },
                format_on_save = {
                    timeout_ms = 500,
                    lsp_fallback = true,
                },
                notify_on_error = true,
            })
        end,
    },
}

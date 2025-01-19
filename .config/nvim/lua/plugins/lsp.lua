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
                    'cssls',
                    'eslint',
                    'gopls',
                    'html',
                    'lua_ls',
                    'pyright',
                    'tailwindcss',
                    'vimls',
                    'yamlls',
                },
                automatic_installation = true,
            })
        end,
    },
    -- {
    --     -- LSP Configuration & Plugins
    --     'neovim/nvim-lspconfig',
    --     dependencies = {
    --         -- Automatically install LSPs to stdpath for neovim
    --         'williamboman/mason.nvim',
    --         'williamboman/mason-lspconfig.nvim',
    --
    --         -- Useful status updates for LSP
    --         -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
    --         { 'j-hui/fidget.nvim', opts = {} },
    --
    --         -- Additional lua configuration, makes nvim stuff amazing!
    --         'folke/neodev.nvim',
    --         'mfussenegger/nvim-jdtls',
    --     },
    --     config = function()
    --         local lspconfig = require('lspconfig')
    --         local lsp_defaults = lspconfig.util.default_config
    --
    --         local mason_lspconfig = require('mason-lspconfig')
    --
    --         -- Use LspAttach autocommand to only map the following keys
    --         -- after the language server attaches to the current buffer
    --         vim.api.nvim_create_autocmd('LspAttach', {
    --             group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    --             callback = function(ev)
    --                 -- Enable completion triggered by <c-x><c-o>
    --                 vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    --
    --                 -- Buffer local mappings.
    --                 -- See `:help vim.lsp.*` for documentation on any of the below functions
    --                 local opts = { buffer = ev.buf }
    --
    --                 -- In this case, we create a function that lets us more easily define mappings specific
    --                 -- for LSP related items. It sets the mode, buffer and description for us each time.
    --                 local nmap = function(keys, func, desc)
    --                     if desc then desc = 'LSP: ' .. desc end
    --
    --                     vim.keymap.set(
    --                         'n',
    --                         keys,
    --                         func,
    --                         { buffer = ev.buf, desc = desc, remap = false }
    --                     )
    --                 end
    --
    --                 -- Go to definitions and references
    --                 nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    --                 nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    --                 nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    --                 nmap('gt', vim.lsp.buf.type_definition, '[G]oto [T]ype Definition')
    --                 nmap('K', vim.lsp.buf.hover, 'Hover definition')
    --                 nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame Symbol')
    --                 nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
    --                 nmap(
    --                     '<leader>ws',
    --                     require('telescope.builtin').lsp_dynamic_workspace_symbols,
    --                     '[W]orkspace [S]ymbol'
    --                 )
    --                 nmap(
    --                     '<leader>ds',
    --                     require('telescope.builtin').lsp_document_symbols,
    --                     '[D]ocument [S]ymbol'
    --                 )
    --                 vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, opts)
    --
    --                 -- Errors inspection
    --                 nmap('<leader>vd', vim.diagnostic.open_float, 'Open [F]loat')
    --                 nmap('[d', vim.diagnostic.goto_next, 'Goto [N]ext')
    --                 nmap(']d', vim.diagnostic.goto_prev, 'Goto [P]rev')
    --                 nmap('<leader>vl', '<cmd>Telescope diagnostics<cr>', '[L]ist')
    --
    --                 -- Restart server
    --                 nmap('<leader>rs', '<cmd>LspRestart<CR>', '[R]estart [S]erver')
    --                 -- Formatting
    --                 nmap('<leader>fm', function()
    --                     vim.lsp.buf.format({ async = true })
    --                     print('formatted')
    --                 end, '[F]or[M]at Code')
    --             end,
    --         })
    --
    --         -- additional capabilities from completions
    --         local capabilities =
    --             require('cmp_nvim_lsp').default_capabilities(lsp_defaults.capabilities)
    --         lsp_defaults.capabilities = capabilities
    --
    --         mason_lspconfig.setup_handlers({
    --             function(server_name)
    --                 lspconfig[server_name].setup({
    --                     capabilities = capabilities,
    --                 })
    --             end,
    --             ['eslint'] = function()
    --                 lspconfig['eslint'].setup({
    --                     capabilities = capabilities,
    --                     settintgs = {
    --                         autoFixOnSave = true,
    --                     },
    --                     on_attach = function(client, bufnr)
    --                         local format_group = 'EslintFormat'
    --                         -- need to set this
    --                         -- Sometimes eslint doesn't register this capabilities.
    --                         client.server_capabilities.documentFormattingProvider = true
    --                         vim.notify('attaching eslint lsp', vim.log.levels.INFO)
    --
    --                         vim.api.nvim_create_autocmd('BufWritePre', {
    --                             group = vim.api.nvim_create_augroup(format_group, { clear = true }),
    --                             buffer = bufnr,
    --                             command = 'EslintFixAll',
    --                         })
    --                     end,
    --                 })
    --             end,
    --             ['lua_ls'] = function()
    --                 -- configure lua server (with special settings)
    --                 lspconfig['lua_ls'].setup({
    --                     capabilities = capabilities,
    --                     settings = {
    --                         Lua = {
    --                             -- make the language server recognize "vim" global
    --                             diagnostics = {
    --                                 globals = { 'vim' },
    --                             },
    --                         },
    --                     },
    --                 })
    --             end,
    --             ['graphql'] = function()
    --                 lspconfig['graphql'].setup({
    --                     capabilities = capabilities,
    --                     root_dir = lspconfig.util.root_pattern(
    --                         '.graphqlconfig',
    --                         '.graphqlrc',
    --                         'package.json',
    --                         '.git'
    --                     ),
    --                 })
    --             end,
    --         })
    --     end,
    -- },
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = {
            'rafamadriz/friendly-snippets',
            'onsails/lspkind.nvim',
        },

        -- use a release tag to download pre-built binaries
        version = '*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- See the full "keymap" documentation for information on defining your own keymap.
            keymap = {
                preset = 'enter',
                ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
                ['<C-up>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-down>'] = { 'scroll_documentation_down', 'fallback' },
            },

            completion = {
                list = {
                    selection = {
                        auto_insert = true,
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 250,
                    treesitter_highlighting = true,
                },
                menu = {
                    cmdline_position = function()
                        if vim.g.ui_cmdline_pos ~= nil then
                            local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                            return { pos[1] - 1, pos[2] }
                        end
                        local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
                        return { vim.o.lines - height, 0 }
                    end,

                    draw = {
                        columns = {
                            { 'label', 'label_description', gap = 1 },
                            { 'kind_icon', 'kind' },
                        },
                        components = {
                            kind_icon = {
                                ellipsis = false,
                                text = function(ctx)
                                    return require('lspkind').symbolic(ctx.kind, {
                                        mode = 'symbol',
                                    })
                                end,
                            },
                        },
                        treesitter = {
                            'lsp',
                        },
                    },
                },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- Will be removed in a future release
                use_nvim_cmp_as_default = false,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono',
            },

            signature = {
                enabled = true,
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
                cmdline = {},
                providers = {
                    lsp = {
                        score_offset = 0, -- Boost/penalize the score of the items
                    },
                },
            },
        },
        opts_extend = { 'sources.default' },
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'saghen/blink.cmp' },

        -- example using `opts` for defining servers
        opts = {
            servers = {
                lua_ls = {
                    diagnostics = {
                        globals = { 'vim' },
                    },
                },
            },
        },
        config = function(_, opts)
            local lspconfig = require('lspconfig')
            local mason_lspconfig = require('mason-lspconfig')
            local capabilities = require('blink.cmp').get_lsp_capabilities()

            mason_lspconfig.setup_handlers({
                function(server)
                    lspconfig[server].setup({
                        capabilities = capabilities,
                        on_attach = function()
                            -- Additional on_attach logic can go here if needed
                        end,
                    })
                end,
                ['eslint'] = function()
                    lspconfig['eslint'].setup({
                        capabilities = capabilities,
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
                end,
                ['lua_ls'] = function()
                    -- configure lua server (with special settings)
                    lspconfig['lua_ls'].setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                -- make the language server recognize "vim" global
                                diagnostics = {
                                    globals = { 'vim' },
                                },
                            },
                        },
                    })
                end,
                ['graphql'] = function()
                    lspconfig['graphql'].setup({
                        capabilities = capabilities,
                        root_dir = lspconfig.util.root_pattern(
                            '.graphqlconfig',
                            '.graphqlrc',
                            'package.json',
                            '.git'
                        ),
                    })
                end,
            })

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
                    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[N]ame Symbol')
                    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
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
                    end, '[F]or[M]at Code')
                end,
            })
        end,
    },
    -- {
    --     -- Autocompletion
    --     'hrsh7th/nvim-cmp',
    --     dependencies = {
    --         -- Snippet Engine & its associated nvim-cmp source
    --         'L3MON4D3/LuaSnip',
    --         'rafamadriz/friendly-snippets',
    --         'benfowler/telescope-luasnip.nvim',
    --
    --         -- Adds LSP completion capabilities
    --         'hrsh7th/cmp-nvim-lsp',
    --         'hrsh7th/cmp-buffer',
    --         'hrsh7th/cmp-path',
    --         'saadparwaiz1/cmp_luasnip',
    --         'hrsh7th/cmp-nvim-lsp',
    --         'hrsh7th/cmp-nvim-lua',
    --     },
    --     event = { 'CmdlineEnter', 'InsertEnter' },
    --     config = function()
    --         local cmp = require('cmp')
    --         local cmp_select = { behavior = cmp.SelectBehavior.Select }
    --
    --         vim.tbl_map(
    --             function(type) require('luasnip.loaders.from_' .. type).lazy_load() end,
    --             { 'vscode', 'snipmate', 'lua' }
    --         )
    --         local luasnip = require('luasnip')
    --         require('luasnip').filetype_extend('lua', { 'luadoc' })
    --         require('luasnip').filetype_extend('python', { 'pydoc' })
    --
    --         -- check if there are words before the cursor
    --         local has_words_before = function()
    --             if vim.api.nvim_buf_get_option(0, 'buftype') == 'prompt' then return false end
    --             local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    --             return col ~= 0
    --                 and vim.api
    --                         .nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]
    --                         :match('^%s*$')
    --                     == nil
    --         end
    --
    --         -- keybinds
    --         local cmp_mappings = cmp.mapping.preset.insert({
    --             ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    --             ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    --             ['<C-Space>'] = cmp.mapping.complete(),
    --             ['<C-x>'] = cmp.mapping.complete(),
    --             ['<CR>'] = cmp.mapping.confirm({ select = true }),
    --             ['<Tab>'] = cmp.mapping(function(fallback)
    --                 if cmp.visible() and has_words_before() then
    --                     cmp.select_next_item()
    --                     return
    --                 end
    --                 fallback()
    --             end, { 'i', 's' }),
    --             ['<S-Tab>'] = cmp.mapping(function(fallback)
    --                 if cmp.visible() then
    --                     cmp.select_prev_item()
    --                     return
    --                 end
    --                 fallback()
    --             end, { 'i', 's' }),
    --             -- jump to next snippet placeholder
    --             ['<C-k>'] = cmp.mapping(function(fallback)
    --                 if luasnip.jumpable(1) then
    --                     luasnip.jump(1)
    --                 else
    --                     fallback()
    --                 end
    --             end, { 'i', 's' }),
    --             ['<C-j>'] = cmp.mapping(function(fallback)
    --                 if luasnip.jumpable(-1) then
    --                     luasnip.jump(-1)
    --                 else
    --                     fallback()
    --                 end
    --             end, { 'i', 's' }),
    --         })
    --
    --         vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
    --
    --         ---@diagnostic disable-next-line: missing-fields
    --         cmp.setup({
    --             -- Snippet engine is required for completions
    --             snippet = {
    --                 expand = function(args)
    --                     require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    --                 end,
    --             },
    --             mapping = cmp_mappings,
    --             window = {
    --                 completion = cmp.config.window.bordered(),
    --                 documentation = cmp.config.window.bordered(),
    --             },
    --
    --             -- Sources tell the snippet engine where to get suggestions from
    --             -- The ordering here is used to sort into final list
    --             sources = cmp.config.sources({
    --                 { name = 'copilot' },
    --                 { name = 'nvim_lsp' },
    --                 { name = 'luasnip' }, -- For luasnip users.
    --                 { name = 'buffer' },
    --                 { name = 'nvim_lua' },
    --                 { name = 'path' },
    --                 { name = 'nvim_lsp_signature_help' }, -- For function signature help
    --             }),
    --         })
    --
    --         local autocmd = vim.api.nvim_create_autocmd
    --         autocmd('FileType', {
    --             pattern = 'oil',
    --             callback = function() require('cmp').setup.buffer({ enabled = false }) end,
    --         })
    --     end,
    -- },
    {
        'stevearc/conform.nvim',
        event = 'VeryLazy',
        config = function()
            require('conform').setup({
                formatters_by_ft = {
                    go = { 'gofumpt' },
                    javascript = { 'eslint' },
                    lua = { 'stylua' },
                    python = { 'isort', 'black' },
                    yaml = { 'yamlfmt' },
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
    {
        'folke/neodev.nvim',
        opts = {},
    },
    {
        'folke/trouble.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            config = function()
                require('trouble').setup({})

                vim.keymap.set(
                    'n',
                    '<leader>xx',
                    function() require('trouble').toggle('diagnostics') end,
                    { desc = 'Toggle Trouble Diagnostics' }
                )
            end,
        },
    },

    {
        'pmizio/typescript-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        config = function() require('typescript-tools').setup({}) end,
    },
}

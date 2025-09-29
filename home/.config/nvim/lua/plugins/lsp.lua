return {
    {
        'neovim/nvim-lspconfig',
    },
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
                'graphql-language-service-cli',
                'shfmt',
                'sqlfluff',
                'stylua',
            },
            registries = {
                'github:mason-org/mason-registry',
                'github:Crashdummyy/mason-registry',
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
        opts = {
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
            automatic_enable = false,
        },
        config = function(_, opts)
            local capabilities = require('blink.cmp').get_lsp_capabilities()

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
                    nmap('<leader>rs', function()
                        vim.cmd('LspRestart')
                        print('LSP server restarted')
                    end, '[R]estart [S]erver')
                    -- Formatting
                    nmap('<leader>fm', function()
                        vim.lsp.buf.format({ async = true })
                        print('formatted')
                    end, '[F]or[M]at Code')
                end,
            })

            vim.lsp.config('*', {
                capabilities = capabilities,
            })

            vim.lsp.config('eslint', {
                capabilities = capabilities,
                settings = {
                    autoFixOnSave = true,
                },
            })
            vim.lsp.config('lua_ls', {
                capabilities = capabilities,
                -- configure lua server (with special settings)
                settings = {
                    Lua = {
                        -- make the language server recognize "vim" global
                        diagnostics = {
                            globals = { 'vim' },
                        },
                    },
                },
            })
            vim.lsp.config('graphql', {
                capabilities = capabilities,
                root_markers = {
                    '.graphqlconfig',
                    '.graphqlrc',
                    'package.json',
                    '.git',
                },
            })

            require('mason').setup()
            require('mason-lspconfig').setup() -- Automatically configures LSP servers
        end,
    },
    {
        'saghen/blink.cmp',
        -- optional: provides snippets for the snippet source
        dependencies = {
            'rafamadriz/friendly-snippets',
            'fang2hou/blink-copilot',
            'kristijanhusak/vim-dadbod-completion',
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
                ['<C-x>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
                ['<C-up>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-down>'] = { 'scroll_documentation_down', 'fallback' },
            },

            completion = {
                accept = {
                    dot_repeat = true,
                },
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
                            { 'kind_icon', 'kind', gap = 1 },
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
                kind_icons = {
                    Copilot = '',
                    Text = '󰉿',
                    Method = '󰊕',
                    Function = '󰊕',
                    Constructor = '󰒓',

                    Field = '󰜢',
                    Variable = '󰆦',
                    Property = '󰖷',

                    Class = '󱡠',
                    Interface = '󱡠',
                    Struct = '󱡠',
                    Module = '󰅩',

                    Unit = '󰪚',
                    Value = '󰦨',
                    Enum = '󰦨',
                    EnumMember = '󰦨',

                    Keyword = '󰻾',
                    Constant = '󰏿',

                    Snippet = '󱄽',
                    Color = '󰏘',
                    File = '󰈔',
                    Reference = '󰬲',
                    Folder = '󰉋',
                    Event = '󱐋',
                    Operator = '󰪚',
                    TypeParameter = '󰬛',
                },
            },

            signature = {
                enabled = true,
            },
            cmdline = {
                sources = {},
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lazydev', 'copilot', 'lsp', 'dadbod', 'path', 'snippets', 'buffer' },
                providers = {
                    lsp = {
                        score_offset = 0, -- Boost/penalize the score of the items
                    },
                    copilot = {
                        name = 'copilot',
                        module = 'blink-copilot',
                        score_offset = 100,
                        async = true,
                        transform_items = function(_, items)
                            local CompletionItemKind = require('blink.cmp.types').CompletionItemKind
                            local kind_idx = #CompletionItemKind + 1
                            CompletionItemKind[kind_idx] = 'Copilot'
                            for _, item in ipairs(items) do
                                item.kind = kind_idx
                            end
                            return items
                        end,
                    },
                    dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
                    lazydev = {
                        name = 'LazyDev',
                        module = 'lazydev.integrations.blink',
                        score_offset = 100,
                    },
                },
            },
        },
        opts_extend = { 'sources.default' },
    },
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
                    sql = { 'sqlfluff' },
                    yaml = { 'yamlfmt' },
                },
                formatters = {
                    python = {
                        require_cwd = false,
                    },
                    sqlfluff = {
                        args = { 'format', '-' },
                    },
                },
                format_on_save = {
                    timeout_ms = 5000,
                    lsp_fallback = true,
                },
                notify_on_error = true,
            })
        end,
    },
    {
        'folke/lazydev.nvim',
        ft = 'lua',
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
        'mfussenegger/nvim-lint',
        config = function()
            require('lint').linters_by_ft = {
                ['sql'] = { 'sqlfluff' },
            }
            vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
                callback = function() require('lint').try_lint() end,
            })
        end,
    },
    {
        'seblj/roslyn.nvim',
        ft = 'cs',
        config = function()
            vim.lsp.config('roslyn', {
                capabilities = require('blink.cmp').get_lsp_capabilities(),
                on_attach = function() print('Roslyn LSP attached') end,
                settings = {
                    ['csharp|code_lens'] = { dotnet_enable_references_code_lens = true },
                },
                handlers = {
                    ['textDocument/hover'] = function(err, result, ctx, config)
                        if result and result.contents and result.contents.value then
                            result.contents.value = result.contents.value:gsub('\\([^%w])', '%1')
                        end
                        vim.lsp.handlers['textDocument/hover'](err, result, ctx, config)
                    end,
                },
            })
            vim.lsp.enable('roslyn')
        end,
    },
}

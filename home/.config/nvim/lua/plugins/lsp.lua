local lmstudio_model = nil
pcall(function()
    local out =
        vim.fn.system('curl -s --connect-timeout 1 http://localhost:1234/v1/models 2>/dev/null')
    if vim.v.shell_error ~= 0 then return end
    local data = vim.json.decode(out)
    if data and data.data and data.data[1] then lmstudio_model = data.data[1].id end
end)
local lmstudio_running = lmstudio_model ~= nil

local blink_default_sources = { 'lazydev', 'lsp', 'dadbod', 'path', 'snippets', 'buffer' }
if lmstudio_running then table.insert(blink_default_sources, 1, 'minuet') end

local pack_specs = {
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/williamboman/mason.nvim' },
    { src = 'https://github.com/williamboman/mason-lspconfig.nvim' },
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
    { src = 'https://github.com/kristijanhusak/vim-dadbod-completion' },
    { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('*') },
    { src = 'https://github.com/stevearc/conform.nvim' },
    { src = 'https://github.com/folke/lazydev.nvim' },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = 'https://github.com/folke/trouble.nvim' },
    { src = 'https://github.com/mfussenegger/nvim-lint' },
}

if lmstudio_running then
    table.insert(pack_specs, { src = 'https://github.com/milanglacier/minuet-ai.nvim' })
end

vim.pack.add(pack_specs)

-- roslyn: loaded only when a C# file is opened
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'cs',
    once = true,
    callback = function()
        vim.pack.add({
            { src = 'https://github.com/seblj/roslyn.nvim' },
        })
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
})

-- mason
local mason_opts = {
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
}

require('mason').setup(mason_opts)

local mr = require('mason-registry')
mr:on('package:install:success', function()
    vim.defer_fn(function()
        vim.api.nvim_exec_autocmds('FileType', {
            buf = vim.api.nvim_get_current_buf(),
            modeline = false,
        })
    end, 100)
end)

local function ensure_installed()
    for _, tool in ipairs(mason_opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then p:install() end
    end
end

if mr.refresh then
    mr.refresh(ensure_installed)
else
    ensure_installed()
end

-- lsp attach
local capabilities = require('blink.cmp').get_lsp_capabilities()

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        local opts = { buffer = ev.buf }

        local nmap = function(keys, func, desc)
            if desc then desc = 'LSP: ' .. desc end
            vim.keymap.set('n', keys, func, { buffer = ev.buf, desc = desc, remap = false })
        end

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

        nmap('<leader>vd', vim.diagnostic.open_float, 'Open [F]loat')
        nmap('[d', vim.diagnostic.goto_next, 'Goto [N]ext')
        nmap(']d', vim.diagnostic.goto_prev, 'Goto [P]rev')
        nmap('<leader>vl', '<cmd>Telescope diagnostics<cr>', '[L]ist')

        nmap('<leader>rs', function()
            vim.cmd('LspRestart')
            print('LSP server restarted')
        end, '[R]estart [S]erver')
        nmap('<leader>fm', function()
            vim.lsp.buf.format({ async = true })
            print('formatted')
        end, '[F]or[M]at Code')
    end,
})

vim.lsp.config('*', { capabilities = capabilities })

vim.lsp.config('eslint', {
    capabilities = capabilities,
    settings = { autoFixOnSave = true },
})
vim.lsp.config('lua_ls', {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
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
    automatic_enable = false,
})

-- blink.cmp
require('blink.cmp').setup({
    keymap = {
        preset = 'enter',
        ['<C-x>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
        ['<C-up>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-down>'] = { 'scroll_documentation_down', 'fallback' },
    },
    completion = {
        accept = { dot_repeat = true },
        list = { selection = { auto_insert = true } },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 250,
            treesitter_highlighting = true,
        },
        menu = {
            cmdline_position = function()
                if vim.g.ui_cmdline_pos ~= nil then
                    local pos = vim.g.ui_cmdline_pos
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
                treesitter = { 'lsp' },
            },
        },
    },
    appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = 'mono',
        kind_icons = {
            Copilot = '',
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
    signature = { enabled = true },
    cmdline = { sources = {} },
    sources = {
        default = blink_default_sources,
        providers = {
            lsp = { score_offset = 0 },
            minuet = {
                name = 'minuet',
                module = 'minuet.blink',
                async = true,
                timeout_ms = 3000,
                score_offset = 50,
            },
            dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
            lazydev = {
                name = 'LazyDev',
                module = 'lazydev.integrations.blink',
                score_offset = 100,
            },
        },
    },
})

require('lazydev').setup({})

if lmstudio_running then
    require('minuet').setup({
        provider = 'openai_fim_compatible',
        n_completions = 5,
        context_window = 1024,
        provider_options = {
            openai_fim_compatible = {
                api_key = 'TERM',
                name = 'LMStudio',
                end_point = 'http://localhost:1234/v1/completions',
                model = lmstudio_model,
                optional = {
                    max_tokens = 56,
                    top_p = 0.9,
                },
            },
        },
    })
end

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
        python = { require_cwd = false },
        sqlfluff = { args = { 'format', '-' } },
    },
    format_on_save = {
        timeout_ms = 5000,
        lsp_fallback = true,
    },
    notify_on_error = true,
})

require('trouble').setup({})
vim.keymap.set(
    'n',
    '<leader>xx',
    function() require('trouble').toggle('diagnostics') end,
    { desc = 'Toggle Trouble Diagnostics' }
)

require('lint').linters_by_ft = { ['sql'] = { 'sqlfluff' } }
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter' }, {
    callback = function() require('lint').try_lint() end,
})

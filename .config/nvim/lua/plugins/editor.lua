return {
  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Time tracking
  'wakatime/vim-wakatime',

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
  {
    'echasnovski/mini.indentscope',
    name = 'mini.indentscope',
    event = 'VeryLazy',
    config = function() 
      require('mini.indentscope').setup({
          draw = {
              delay = 40,
              priority = 20,
              animation = require('mini.indentscope').gen_animation.exponential({
                  easing = 'in-out',
                  duration = 80,
                  unit = 'total',
              }),
          },
          symbol = '┃',
          options = {
              try_as_border = true,
          },
          mappings = {
              goto_top = '',
              goto_bottom = '',
              object_scope = '',
              object_scope_with_border = '',
          },
    })

    local disabled = {
        'harpoon',
        'help',
        'terminal',
    }

    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function()
        if disabled[vim.bo.filetype] ~= nil or vim.bo.buftype ~= '' then
          vim.b.miniindentscope_disable = true
        end
      end,
    })

    vim.cmd([[highlight! link MiniIndentscopeSymbol Identifier]])
  end
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
}

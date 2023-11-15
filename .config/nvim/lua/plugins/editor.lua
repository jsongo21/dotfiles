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

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
}

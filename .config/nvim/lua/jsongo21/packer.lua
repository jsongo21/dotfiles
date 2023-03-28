-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	use {
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

   ---- TOKYONIGHT ----
    --[[ use({
    	'folke/tokyonight.nvim',
      	config = function()
       		require("tokyonight").setup()
       		vim.cmd('colorscheme tokyonight')
       	end
       }) ]]

   ---- GRUVBOX ----
     use({
    	'ellisonleao/gruvbox.nvim',
      	config = function()
       		require("gruvbox").setup()
            vim.o.background = 'dark'
       		vim.cmd('colorscheme gruvbox')
       	end
       })

   ---- ROSE PINE ----
    --use({
      --	'rose-pine/neovim',
      --	as = 'rose-pine',
      --	config = function()
        --		require("rose-pine").setup()
        --		vim.cmd('colorscheme rose-pine')
        --	end
        --})

   ---- KANAGAWA ----
    --[[ use({
      'rebelot/kanagawa.nvim',
      config = function()
        require('kanagawa').setup{
          colors = {
            theme = {
              all = {
                ui = {
                  bg_gutter = 'none',
                  float = {
                    bg = 'none'
                  }
                }
              }
            }
          }
        }
        vim.cmd('colorscheme kanagawa')
      end
    }) ]]

   ---- CATPPUCCIN ----
    --[[ use({
      'catppuccin/nvim',
      as = 'catppuccin',
      config = function()
        require('catppuccin').setup({
          flavour = 'mocha',
        }) 
        vim.cmd('colorscheme catppuccin')
      end
    }) ]]

   ---- ONE DARK ----
    --[[ use({
      'navarasu/onedark.nvim',
      config = function()
        require('onedark').setup {
   --------------
          style = 'warm'
        }
        require('onedark').load()
      end
    }) ]]

   ---- DRACULA ----
    --[[ use({
      'Mofiqul/dracula.nvim',
      config = function()
        require('dracula').setup({
        })
        vim.cmd('colorscheme dracula')
      end
    }) ]]

    use('nvim-treesitter/nvim-treesitter',{	run = ':TSUpdate'})
    use('theprimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use {
      'VonHeikemen/lsp-zero.nvim',
      requires = {
        -- LSP Support
        {'neovim/nvim-lspconfig'},
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},

		  -- Autocompletion
		  {'hrsh7th/nvim-cmp'},
		  {'hrsh7th/cmp-buffer'},
		  {'hrsh7th/cmp-path'},
		  {'saadparwaiz1/cmp_luasnip'},
		  {'hrsh7th/cmp-nvim-lsp'},
		  {'hrsh7th/cmp-nvim-lua'},

          -- Snippets
          {'L3MON4D3/LuaSnip'},
          {'rafamadriz/friendly-snippets'},
        }
      }
      use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
      }
      use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
      }
      use {
        "windwp/nvim-ts-autotag",
        config = function() require("nvim-ts-autotag").setup {} end
      }

      use {
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
        config = function()
          require("trouble").setup {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
          }
        end
      }

      use {
        'lewis6991/gitsigns.nvim',
      }

      use {
        'numToStr/Comment.nvim',
        config = function()
          require('Comment').setup({
            pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
          })
        end
      }

      use {
        'JoosepAlviste/nvim-ts-context-commentstring',
      }

    end)

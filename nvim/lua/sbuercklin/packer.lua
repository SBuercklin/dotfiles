-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Packer can manage itself
	use('wbthomason/packer.nvim')

	-- telescope
	use({
		'nvim-telescope/telescope.nvim', tag = '0.1.1',
		-- or                            , branch = '0.1.x',
		requires = { {'nvim-lua/plenary.nvim'} }
	})

	-- treesitter
	use({
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	})
	use({'nvim-treesitter/playground'})

	-- undo tree
	use({'mbbill/undotree'})

    -- Julia support
    use { 'JuliaEditorSupport/julia-vim'}

	-- LSP
	use {
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
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

    -- Git integration
    use { 'tpope/vim-fugitive' }

    -- Comments
    use {
        'tpope/vim-commentary'
    }

    -- Git gutter
    use {
        'airblade/vim-gitgutter'
    }

    -- bqf and fzf
    use {'kevinhwang91/nvim-bqf', ft = 'qf'}
    use {'junegunn/fzf', run = function()
        vim.fn['fzf#install']()
    end
    }

    -- auto-pairs
    use {'LunarWatcher/auto-pairs'}

    -- nvim-tree explorer
    use {'nvim-tree/nvim-tree.lua',
    config = function() 
        require("nvim-tree").setup {
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = false,
            }
        }
    end
    }

    -- Allows fancy icons, install a patched font set into ~/.fonts from nerdfonts.com
    -- e.g. Caskaydia Cove
    use {'nvim-tree/nvim-web-devicons'}

	-- Set the theme in lua/sbuercklin/init.lua
	use({ "bluz71/vim-nightfly-colors", as = "nightfly" })

end)

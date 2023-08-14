-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Install packer:
-- git clone --depth 1 https://github.com/wbthomason/packer.nvim\
--  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
-- Packer can manage itself
use ( { 'wbthomason/packer.nvim' } )

-- undo tree
use( { 'mbbill/undotree' } )

-- Git integration
use ( { 'tpope/vim-fugitive' } )
use ( { 'airblade/vim-gitgutter' } )

-- Comments
use ( { 'tpope/vim-commentary' } )

-- auto-pairs
use (
    {
       'windwp/nvim-autopairs',
    }
)

-- telescope, treesitter
use(
    {
       -- or                            , branch = '0.1.x',
       'nvim-telescope/telescope.nvim',
       tag = '0.1.1',
       requires = { {'nvim-lua/plenary.nvim'} },
    }
)
use(
    {
       'nvim-treesitter/nvim-treesitter',
       run = ':TSUpdate'
    }
)

-- vim surround
use(
    {
       "kylechui/nvim-surround",
       tag = "*", -- Use for stability; omit to use `main` branch for the latest features
       config = function()
           require("nvim-surround").setup(
               {
                  -- config here
               }
           )
        end
    }
)

-- fzf
use (
    {
        'junegunn/fzf',
        run = function()
            vim.fn['fzf#install']()
        end
    }
)

-- bqf, "better quick fix", gives a popup preview in qf
use ( {'kevinhwang91/nvim-bqf', ft = 'qf'} )

-- nvim-tree explorer
use (
    {
        'nvim-tree/nvim-tree.lua',
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
)

-----------------------------------------
-- LSP autocomplete, languages
-----------------------------------------
use ( {'neovim/nvim-lspconfig'} )
use ( {'williamboman/mason.nvim'} )
use ( {'williamboman/mason-lspconfig.nvim'} )

-- nvim-cmp engine and autocomplete locations
use ( {'hrsh7th/nvim-cmp'} )
use ( {'hrsh7th/cmp-cmdline'} )
use ( {'hrsh7th/cmp-buffer'} )
use ( {'hrsh7th/cmp-nvim-lua'} )
use ( {'hrsh7th/cmp-nvim-lsp'} )

use ( {'rafamadriz/friendly-snippets'} )
use ( {'L3MON4D3/LuaSnip'} )
use ( {'saadparwaiz1/cmp_luasnip'} )

-- Language support
use ( {'simrat39/rust-tools.nvim'} )
use( { 'JuliaEditorSupport/julia-vim'} )

-----------------------------------------
-- Everything below here is purely visual
-----------------------------------------

-- Allows fancy icons, install a patched font set into ~/.fonts from nerdfonts.com
-- e.g. Caskaydia Cove
use {'nvim-tree/nvim-web-devicons'}

-- Set the theme in lua/sbuercklin/init.lua
use({ "bluz71/vim-nightfly-colors", as = "nightfly" })
use ( { "rebelot/kanagawa.nvim" } ) -- lighter background for screenshots, :set background=light

end)

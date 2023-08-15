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
use( 
    { 
        'mbbill/undotree',
        config = function () 
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

            -- Focuses the undo tree when it's opened
            vim.api.nvim_set_var("undotree_SetFocusWhenToggle", 1)

            vim.api.nvim_set_var("undotree_WindowLayout", 2)
        end
    } 

)

-- Git integration
use ( 
    { 
        'tpope/vim-fugitive' ,
        config = function () 
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
            vim.keymap.set("n", "<leader>gb", function() vim.cmd({ cmd = 'Git', args = { 'blame' } }) end)

            vim.keymap.set("n", "<leader>glg", 
                function() 
                    vim.cmd({ cmd = 'Git',  args = { 'log --graph --oneline' } }) 
                end
                )
            vim.keymap.set("n", "<leader>gll", 
                function() 
                    vim.cmd({ cmd = 'Git',  args = { 'log --graph --oneline --all' } }) 
                end
                )
        end
    } 
)
use ( { 'airblade/vim-gitgutter' } )

-- Comments
use ( 
    { 
        'tpope/vim-commentary',
        config = function () 
            vim.keymap.set("n", "<C-_>", vim.cmd.Commentary)
            vim.keymap.set("i", "<C-_>", vim.cmd.Commentary)

            -- Enable visual mode by getting the lines and then pass to commentary
            function comment_visual()
                local strt = math.min(vim.fn.line("v"), vim.fn.line("."))
                local stp = math.max(vim.fn.line("v"), vim.fn.line("."))

                vim.cmd(tostring(strt) .. "," .. tostring(stp) .. "Commentary")
            end

            vim.keymap.set("v", "<C-_>", comment_visual)
        end
    } 
)

-- auto-pairs
use (
    {
       'windwp/nvim-autopairs',
       config = function () 
           require('nvim-autopairs').setup( 
               {
                  enable_check_bracket_line = false,
                  ignored_next_char = "[%w%.]"
               } 
           )
       end
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
        run = ':TSUpdate',
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
            config = function ()
                vim.g.loaded_netrw = 1
                vim.g.loaded_netrwPlugin = 1
            end
        end
    }
)

use(
    {
    "aserowy/tmux.nvim",
    config = function()
        local tmux = require("tmux")

        tmux.setup(
            {
                navigation = {
                    cycle_navigation = false,
                    enable_default_keybindings = false,
                },
                resize = {
                    enable_default_keybindings = false,
                }
            }
        )


        vim.keymap.set("n", "<A-h>", tmux.move_left)
        vim.keymap.set("n", "<A-j>", tmux.move_bottom)
        vim.keymap.set("n", "<A-k>", tmux.move_top)
        vim.keymap.set("n", "<A-l>", tmux.move_right)
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

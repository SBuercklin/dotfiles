local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


-- opts = {}

local plugins = {
    -- Undotree
    { 
        'mbbill/undotree',
        keys = {
            {"<leader>u", vim.cmd.UndotreeToggle, mode = "n", "Toggled undo-tree"},
        },
        config = function () 
            -- Focuses the undo tree when it's opened
            vim.api.nvim_set_var("undotree_SetFocusWhenToggle", 1)
            vim.api.nvim_set_var("undotree_WindowLayout", 2)
        end
    },

    -- Fugitive, git interation
    {
        'tpope/vim-fugitive',
        event = "VeryLazy",
        keys = {
            {"<leader>gs", vim.cmd['Git'], mode = "n", desc = "git status in nvim"},
            {"<leader>gb", function() vim.cmd( { cmd = 'Git', args = {'blame'} }) end, mode = "n", desc = "git blame for current buffer"},
            {"<leader>glg", 
                function() 
                    vim.cmd({cmd = 'Git', args = {'log --graph --oneline'}}) 
                end, 
                mode = "n", 
                desc = "git log graph, current branch"
            },
            {"<leader>gll", 
                function() 
                    vim.cmd({cmd = 'Git', args = {'log --graph --oneline --all'}}) 
                end,
                mode = "n", 
                desc = "git log graph"
            },
        }
    },

    -- Git gutter
    { 
        'airblade/vim-gitgutter' 
    },

    -- Commentary, comments
    {
        'tpope/vim-commentary',
        keys = {
            {"<C-_>", vim.cmd.Commentary, mode = "n", desc = "Comment current line"},
            {"<C-_>", vim.cmd.Commentary, mode = "i", desc = "Comment current line"},
            {
                "<C-_>", 
                function () 
                    local strt = math.min(vim.fn.line("v"), vim.fn.line("."))
                    local stp = math.max(vim.fn.line("v"), vim.fn.line("."))
                    vim.cmd(tostring(strt) .. "," .. tostring(stp) .. "Commentary")
                end, 
                mode = "v", 
                desc = "Comment current visual selection" 
            }
        }
    },

    -- Autopairs
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
    },

    -- Telescope
    {
       'nvim-telescope/telescope.nvim',
       version = '0.1.5',
       dependencies = { {'nvim-lua/plenary.nvim'} },
       keys = {
           { "<leader>fg", require("telescope.builtin").live_grep }
       }
    },

    -- Treesitter
    -- NOTE: You might need to delete/remove/etc the local installation of parsers for 
    -- languages, and if you're coming from packer then it can also cause parser issues
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
        config = function ()
            local configs = require("nvim-treesitter.configs") 
            configs.setup(
            {
                -- parser_install_dir = "~/.local/share/nvim/site/parsers",

                ensure_installed = { "lua", "vim", "vimdoc", "query", "julia", "python", "rust", "latex" },

                -- If you need to change the installation directory of the parsers (see -> Advanced Setup)
                -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

                highlight = {
                    enable = true,
                    disable = function(lang, buf)
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                        if lang == "lua" then
                            return true
                        end
                    end,
                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "cn", -- set to `false` to disable one of the mappings
                        node_incremental = "ck",
                        scope_incremental = false,
                        node_decremental = "cj",
                    },
                }
            }
            )
        end
    },

    -- vim surround, useful motions
    {
       "kylechui/nvim-surround",
       version = "*", 
       event = "VeryLazy",
    },

    -- Better tree than netrw
    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            local tree_augroup = vim.api.nvim_create_augroup("nvimtree", {clear = true})
            local nvtree = require("nvim-tree")
            local nvtreeapi = require("nvim-tree.api")
            nvtree.setup {
                renderer = {
                   group_empty = true,
                },
                filters = {
                   dotfiles = false,
                }
            }
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrwPlugin = 1   

            vim.api.nvim_create_autocmd(
                'TabEnter', 
                { 
                    group = tree_augroup,
                    callback = function(ev)
                        local tcwd = vim.fn.getcwd(0,0)
                        nvtreeapi.tree.change_root(tcwd)
                    end 
                }
            )
        end
    },

    -----------------------------------------
    -- LSP autocomplete, languages
    -----------------------------------------
     {'neovim/nvim-lspconfig'},
     {'williamboman/mason.nvim'},
     {'williamboman/mason-lspconfig.nvim'},

    -- nvim-cmp engine and autocomplete locations
     {'hrsh7th/nvim-cmp'},
     {'hrsh7th/cmp-cmdline'},
     {'hrsh7th/cmp-buffer'},
     {'hrsh7th/cmp-nvim-lua'},
     {'hrsh7th/cmp-nvim-lsp'},
     {'kdheepak/cmp-latex-symbols'},  -- needed for Julia autocomplete of symbol

     {'rafamadriz/friendly-snippets'},
     {'L3MON4D3/LuaSnip'},
     {'saadparwaiz1/cmp_luasnip'},

     -- Language support
     {'simrat39/rust-tools.nvim'},
     {'JuliaEditorSupport/julia-vim'},

    -----------------------------------------
    -- Visual stuff
    -----------------------------------------
    -- Dev icons
    {'nvim-tree/nvim-web-devicons'},

    -- Colorscheme
    { "bluz71/vim-nightfly-colors", name = "nightfly" },
}

-- require("lazy").setup(plugins, opts)
require("lazy").setup(plugins)

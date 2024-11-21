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


local opts = {}

local plugins = {
    require "sbuercklin/configs/telescope", -- Telescope picker, generally <leader>f_ where _ is some key to open a picker
    require "sbuercklin/configs/lspconfig",
    require "sbuercklin/configs/treesitter",
    require "sbuercklin/configs/cmp",      -- autocomplete, sources, etc
    require "sbuercklin/configs/neotest",  -- neotest and adapters
    require "sbuercklin/configs/nvim-dap", -- DAP, UI, and adapters

    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            local tree_augroup = vim.api.nvim_create_augroup("nvimtree", { clear = true })
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
                        local tcwd = vim.fn.getcwd(0, 0)
                        nvtreeapi.tree.change_root(tcwd)
                    end
                }
            )
        end
    },
    {
        'mbbill/undotree', -- Tree-view of undo history
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, mode = "n", "Toggled undo-tree" },
        },
        config = function()
            -- Focuses the undo tree when it's opened
            vim.api.nvim_set_var("undotree_SetFocusWhenToggle", 1)
            vim.api.nvim_set_var("undotree_WindowLayout", 2)
        end
    },
    {
        'kevinhwang91/nvim-bqf', -- quick fix preview, < or > to cycle, zn or zN to filter qflist
        ft = 'qf'
    },
    {
        'tpope/vim-fugitive',
        dependencies = {
            'shumphrey/fugitive-gitlab.vim',
        },
        lazy = false,
        keys = {
            {
                "<leader>gs",
                vim.cmd['Git'],
                mode = "n",
                desc = "git status in nvim"
            },
            {
                "<leader>gb",
                function() vim.cmd({ cmd = 'Git', args = { 'blame' } }) end,
                mode = "n",
                desc = "git blame for current buffer"
            },
            {
                "<leader>glg",
                function() vim.cmd({ cmd = 'Git', args = { 'log --graph --oneline' } }) end,
                mode = "n",
                desc = "git log graph, current branch"
            },
            {
                "<leader>gll",
                function() vim.cmd({ cmd = 'Git', args = { 'log --graph --oneline --all' } }) end,
                mode = "n",
                desc = "git log graph"
            },
        }
    },
    {
        'airblade/vim-gitgutter'
    },
    {
        "kylechui/nvim-surround", -- Surround motions, e.g. cs"} to change surrounding " to matched }
        opts = {}
    },
    {
        'echasnovski/mini.splitjoin', -- gS to split/combine inside brackets
        keys = { "gS", }
    },
    {
        'numToStr/Comment.nvim', -- Comments. gbc for block comments, gcc for regular comments, g{b,c}<movement> also works
        opts = {},
    },
    {
        'windwp/nvim-autopairs', -- Autopairs
        opts = {
            enable_check_bracket_line = false,
            ignored_next_char = "[%w%.]"
        }
    },

    {
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
            },
        },
        { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    },
    {
        "aserowy/tmux.nvim",
        opts = {
            navigation = {
                cycle_navigation = false,
                enable_default_keybindings = false,
            },
            resize = {
                enable_default_keybindings = false,
            },
            copy_sync = {
                enable = false,         -- I like persisting my individual nvim registers
                sync_clipboard = false, -- but if I did want this, I want to manage the clipboard
            }
        },
        keys = {
            { "<A-h>", require('tmux').move_left,   desc = "tmux-compatible move left" },
            { "<A-j>", require('tmux').move_bottom, desc = "tmux-compatible move down" },
            { "<A-k>", require('tmux').move_top,    desc = "tmux-compatible move up" },
            { "<A-l>", require('tmux').move_right,  desc = "tmux-compatible move right" },
        }
    },
    {
        'jpalardy/vim-slime',
        config = function()
            vim.g.slime_target = "tmux"
            -- let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
        end
    },

    {
        'JuliaEditorSupport/julia-vim',
        filetype = "julia"
    },
    { 'nvim-tree/nvim-web-devicons' },
    { "bluz71/vim-nightfly-colors", name = "nightfly" }, -- Colorscheme

    -----------------------------------------
    -- Local projects and stuff
    -----------------------------------------
    {
        dir = vim.fn.stdpath("config") .. "/local-plugins/samlib/",
        name = "samlib",
        opts = {},
    },

    -- My preferred tmux integration with keybinds and whatnot
    require "sbuercklin/configs/stmux",

    {
        dir = vim.fn.stdpath("config") .. "/local-plugins/sslime/",
        name = "sslime",
        dependencies = { "samlib", "jpalardy/vim-slime" },
        opts = {},
    },
    require "sbuercklin/configs/snotes", -- Note integrations, probably  want to just rewrite this
}

require("lazy").setup(plugins, opts)

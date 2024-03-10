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
        keys = {
            {
                "<leader>gs",
                vim.cmd['Git'],
                mode = "n",
                desc = "git status in nvim"
            },
            {
                "<leader>gb",
                function() vim.cmd( { cmd = 'Git', args = {'blame'} }) end,
                mode = "n",
                desc = "git blame for current buffer"
            },
            {
                "<leader>glg",
                function() vim.cmd({cmd = 'Git', args = {'log --graph --oneline'}}) end,
                mode = "n",
                desc = "git log graph, current branch"
            },
            {
                "<leader>gll",
                function() vim.cmd({cmd = 'Git', args = {'log --graph --oneline --all'}}) end,
                mode = "n",
                desc = "git log graph"
            },
        }
    },

    -- Git gutter
    { 
        'airblade/vim-gitgutter' 
    },

    -- Comments. gbc for block comments, gcc for regular comments, g{b,c}<movement> also works
    {
        'numToStr/Comment.nvim',
        opts = {},
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
       config = function()
        require("nvim-surround").setup({})
       end
    },

    -- gS to split/combine contents across multiple lines
    {
        'echasnovski/mini.splitjoin', 
        version = '*',
        config = true,
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

    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf'
    },

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
                    },
                    copy_sync = {
                        enable = false, -- I like persisting my individual nvim registers
                        sync_clipboard = false, -- but if I did want this, I want to manage the clipboard
                    }
                }
            )


            vim.keymap.set("n", "<A-h>", tmux.move_left)
            vim.keymap.set("n", "<A-j>", tmux.move_bottom)
            vim.keymap.set("n", "<A-k>", tmux.move_top)
            vim.keymap.set("n", "<A-l>", tmux.move_right)
        end
    },

    {
        'jpalardy/vim-slime',
        config = function()
            vim.g.slime_target = "tmux"
            -- let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
        end
    },

    -----------------------------------------
    -- LSP autocomplete, languages
    -----------------------------------------
     {
         'neovim/nvim-lspconfig',
         dependencies = {
             {'williamboman/mason.nvim'},
             {'williamboman/mason-lspconfig.nvim'},
             {'hrsh7th/cmp-nvim-lsp'},
             {'simrat39/rust-tools.nvim'},
         },
         config = function (_, opts)
            local lsp = require('lspconfig')
            local lib = require('sbuercklin.lib')

            -- require('mason').setup()

            local capabilities = require('cmp_nvim_lsp').default_capabilities
            local keymap_opts = { noremap = true, silent = true, buffer = bufnr }

            -- Enable LSP logging
            -- vim.lsp.set_log_level("debug")

            -- Diagnostic shortcuts, pulled from lspconfig docs
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

            local attach_fn = function(client, bufnr)
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, keymap_opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, keymap_opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, keymap_opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, keymap_opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, keymap_opts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, keymap_opts)
                vim.keymap.set('n', 'F2', vim.lsp.buf.rename, keymap_opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, keymap_opts)
                vim.keymap.set('n', '<leader>jf', vim.lsp.buf.format, keymap_opts)
            end

            local format_autocmd = function(bufnr)
                vim.api.nvim_create_autocmd(
                    'BufWritePre', {
                        callback = function(ev)
                            vim.lsp.buf.format()
                        end,
                        buffer = bufnr
                    }
                )
            end

            --------------------------------------------
            -- Language specific configurations
            --------------------------------------------

            lsp.julials.setup(
                {
                    on_attach = function(client, bufnr)
                        attach_fn(client, bufnr)

                        -- This is used to determine if we want to autoformat
                        --  kinda hacky but it works
                        local fname = vim.api.nvim_buf_get_name(0)
                        local dname = vim.fs.dirname(fname)
                        local dirs = vim.fs.find('.JuliaFormatter.toml',  { upward = true, path = dname })
                        if not(next(dirs) == nil) then
                            format_autocmd(bufnr)
                        end
                    end,
                    capabilities = capabilities()
                }
            )

            -- Requires latexindent and latexmk for formatting and building respectively
            lsp.texlab.setup(
                {
                    on_attach = function(client, bufnr)
                        attach_fn(client, bufnr)
                        format_autocmd(bufnr)
                        vim.keymap.set("n", "<Leader>jm", vim.cmd["TexlabBuild"])
                    end,
                    capabilities = capabilities(),
                    settings = {
                        texlab = {
                            build = {
                              executable = 'latexmk',
                              args = { '-shell-escape', '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
                            }
                        }
                    }
                }
            )

            -- Note that to configure the pyright env, use the venv and venvPath entries in the project config:
            --    https://github.com/microsoft/pyright/blob/main/docs/configuration.md
            lsp.pyright.setup(
                {
                    on_attach = function(client, bufnr)
                        attach_fn(client, bufnr)
                    end,
                    capabilities = capabilities()
                }
            )

            local rt = require("rust-tools")
            rt.setup(
                {
                    server = {
                        on_attach = function(client, bufnr)
                            attach_fn(client, bufnr)
                            
                            format_autocmd(bufnr)
                            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, keymap_opts)
                            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, keymap_opts)
                        end
                    }
                }
            )
         end
     },

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

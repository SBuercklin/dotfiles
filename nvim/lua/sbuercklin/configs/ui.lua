return {
    -- Undotree, used for getting a tree-view of undo history
    {
        'mbbill/undotree',
        keys = {
            { "<leader>u", vim.cmd.UndotreeToggle, mode = "n", "Toggled undo-tree" },
        },
        config = function()
            -- Focuses the undo tree when it's opened
            vim.api.nvim_set_var("undotree_SetFocusWhenToggle", 1)
            vim.api.nvim_set_var("undotree_WindowLayout", 2)
        end
    },

    -- Better quick fix, this is mainly used for getting a popup preview of the local
    --  context for entries in the quickfix list
    {
        'kevinhwang91/nvim-bqf',
        ft = 'qf'
    },

    -- Better tree than netrw, <leader>e opens a LHS tree view of the directory
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

    -- Fugitive, git interation
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

    -- Git gutter
    {
        'airblade/vim-gitgutter'
    },
}

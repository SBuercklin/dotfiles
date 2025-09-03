return {
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
                git_ignored = false,
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
}

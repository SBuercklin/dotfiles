vim.g.tmux_navigator_no_mappings = 1
vim.g.tmux_navigator_no_wrap = 1

return {

    "christoomey/vim-tmux-navigator",
    keys = {
        { "<A-h>", "<cmd>TmuxNavigateLeft<cr>" },
        { "<A-j>", "<cmd>TmuxNavigateDown<cr>" },
        { "<A-k>", "<cmd>TmuxNavigateUp<cr>" },
        { "<A-l>", "<cmd>TmuxNavigateRight<cr>" },
    },
    lazy = false
}

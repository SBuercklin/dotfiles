-- tmux navigator to avoid having to write tmux-integrated nav myself
-- stmux is my personal plugin to to handle attaching/detaching panes from windows

vim.g.tmux_navigator_no_mappings = 1
vim.g.tmux_navigator_no_wrap = 1
return {
    {

        "christoomey/vim-tmux-navigator",
        keys = {
            { "<A-h>", "<cmd>TmuxNavigateLeft<cr>" },
            { "<A-j>", "<cmd>TmuxNavigateDown<cr>" },
            { "<A-k>", "<cmd>TmuxNavigateUp<cr>" },
            { "<A-l>", "<cmd>TmuxNavigateRight<cr>" },
        },
        lazy = false
    },
    {
        dir = vim.fn.stdpath("config") .. "/local-plugins/stmux/",
        name = "stmux",
        -- cond = true, -- TODO: Change this to check if you're in a tmux window and disable if not
        opts = {},
        keys = {
            {
                "<leader>jr",
                function() require("stmux").attach_new_pane() end,
                desc = "Attach new tmux pane to current window"
            },
            {
                "<leader>jd",
                function() require("stmux").detach_pane('tstash') end,
                desc = "Detach attached pane from current window"
            },
            {
                "<leader>jp",
                function() require("stmux").toggle_attached_pane() end,
                desc = "Toggle visibility of attached pane"
            },
            {
                "<leader>jq",
                function() require("stmux").kill_attached_pane() end,
                desc = "Kill attached pane"
            },
        },
    }
}

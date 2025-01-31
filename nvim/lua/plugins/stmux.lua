return {
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

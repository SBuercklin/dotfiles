return {
    dir = vim.fn.stdpath("config") .. "/local-plugins/srust/",
    name = "srust",
    -- cond = true, -- TODO: Change this to check if you're in a tmux window and disable if not
    opts = {},
    dependencies = {
        "samlib",
        "stmux",
        "sslime"
    },
    ft = "rust"
}

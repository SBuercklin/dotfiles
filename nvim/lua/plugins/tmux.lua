return {
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
            enable = false,             -- I like persisting my individual nvim registers
            sync_clipboard = false,     -- but if I did want this, I want to manage the clipboard
        }
    },
    keys = {
        { "<A-h>", function () require('tmux').move_left() end,   desc = "tmux-compatible move left" },
        { "<A-j>", function () require('tmux').move_bottom() end, desc = "tmux-compatible move down" },
        { "<A-k>", function () require('tmux').move_top() end,    desc = "tmux-compatible move up" },
        { "<A-l>", function () require('tmux').move_right() end,  desc = "tmux-compatible move right" },
    }
}

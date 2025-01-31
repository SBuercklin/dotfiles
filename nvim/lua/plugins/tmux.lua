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
        { "<A-h>", require('tmux').move_left,   desc = "tmux-compatible move left" },
        { "<A-j>", require('tmux').move_bottom, desc = "tmux-compatible move down" },
        { "<A-k>", require('tmux').move_top,    desc = "tmux-compatible move up" },
        { "<A-l>", require('tmux').move_right,  desc = "tmux-compatible move right" },
    }
}

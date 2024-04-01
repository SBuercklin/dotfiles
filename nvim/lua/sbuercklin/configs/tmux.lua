return {
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
    }

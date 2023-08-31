local slime = require("sbuercklin.slime")
local tmux = require("sbuercklin.tmux")

if slime.slime_active() then
    function slime.send_to_terminal(str)
        local pane_tgt = tmux.get_tab_terminal_pane()
        if slime.slime_active() and pane_tgt then
            vim.b.slime_config = {socket_name = "default", target_pane = pane_tgt }

            vim.cmd.SlimeSend1(str)
        end
    end

    function slime.send_line()
        slime.send_to_terminal(vim.api.nvim_get_current_line())
    end

    function slime.send_visual()
        -- Yank visual selection into v register
        -- Reference: https://www.reddit.com/r/neovim/comments/oo97pq/how_to_get_the_visual_selection_range/
        vim.cmd('noau normal! "vy"')
        local contents = vim.fn.getreg('"v')
        slime.send_to_terminal(contents)
    end
end

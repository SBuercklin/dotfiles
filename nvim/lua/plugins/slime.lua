local send_line_increment = function()
    local tmux = require("stmux")
    local pane_tgt = tmux.get_tab_terminal_pane()
    if pane_tgt then
        vim.b.slime_config = { socket_name = "default", target_pane = pane_tgt }
        vim.cmd('SlimeSend')
        vim.cmd('normal j')
    end
end

local send_selection_increment = function()
    local tmux = require("stmux")
    local pane_tgt = tmux.get_tab_terminal_pane()

    if pane_tgt then
        vim.b.slime_config = { socket_name = "default", target_pane = pane_tgt }
        -- Yank visual selection into v register
        -- Reference: https://www.reddit.com/r/neovim/comments/oo97pq/how_to_get_the_visual_selection_range/
        vim.cmd('noau normal! "vy"')
        local contents = vim.fn.getreg('"v')
        vim.cmd.SlimeSend1(contents)
    end
end

local send_motion = function()
    local tmux = require("stmux")
    local pane_tgt = tmux.get_tab_terminal_pane()
    if pane_tgt then
        vim.b.slime_config = { socket_name = "default", target_pane = pane_tgt }
        local old_func = vim.go.operatorfunc
        vim.go.operatorfunc = 'slime#send_op'
        vim.api.nvim_feedkeys('g@', 'n', false)
    end
end

return {
    'jpalardy/vim-slime',
    dependencies = {
        "stmux"
    },
    config = function()
        vim.g.slime_target = "tmux"
    end,
    keys = {
        { "<leader>s", send_line_increment,      mode = "n", desc = "Slime send current line" },
        { "<leader>s", send_selection_increment, mode = "v", desc = "Slime send current selection" },
        { "<leader>m", send_motion,              mode = "n", desc = "Slime send motion" },
    }
}

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
        vim.api.nvim_feedkeys('v', 'v', {})
        vim.cmd('SlimeSend')
        vim.cmd('normal j')
        vim.api.nvim_feedkeys('gv', 'n', {})
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

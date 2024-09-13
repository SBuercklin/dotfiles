local lib = require("samlib")
local tmux = require("stmux")

local M = {}

function M.slime_active()
    return vim.g.loaded_slime
end

function M.send_to_terminal(str)
    local pane_tgt = tmux.get_tab_terminal_pane()
    if M.slime_active() and pane_tgt then
        vim.b.slime_config = { socket_name = "default", target_pane = pane_tgt }

        vim.cmd.SlimeSend1(str)
    end
end

function M.send_line()
    M.send_to_terminal(vim.api.nvim_get_current_line())
end

function M.send_visual()
    -- Yank visual selection into v register
    -- Reference: https://www.reddit.com/r/neovim/comments/oo97pq/how_to_get_the_visual_selection_range/
    vim.cmd('noau normal! "vy"')
    local contents = vim.fn.getreg('"v')
    M.send_to_terminal(contents)
end

local function execute_f_and_increment(f)
    local loc = vim.api.nvim_win_get_cursor(0)
    loc[1] = loc[1] + 1
    f()
    vim.api.nvim_win_set_cursor(0, loc)
end

local function wrap_with_line_increment(f)
    return function()
        execute_f_and_increment(f)
    end
end

M.setup = function(opts)
    vim.keymap.set('n', '<C-m>', wrap_with_line_increment(M.send_line))
    vim.keymap.set('v', '<C-m>', wrap_with_line_increment(M.send_visual))
end

return M

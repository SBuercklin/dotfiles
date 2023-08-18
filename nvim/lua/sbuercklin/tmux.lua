local lib = require("sbuercklin.lib")
local run_cmd = vim.fn.system
local api = vim.api

local M = {}

function build_tmux_cmd(opts)
    local cmd = 'tmux'
    cmd = cmd .. pad_str(opts.cmd)
    if opts.flags then
        for _,f in pairs(opts.flags) do 
            cmd = cmd .. pad_str('-' .. f)
            if opts[f] then
                cmd = cmd .. pad_str(opts[f])
            end
        end
    end
    if opts.target then
        cmd = cmd .. pad_str('-t ' .. opts.target)
    end
    if opts.source then
        cmd = cmd .. pad_str('-s ' .. opts.source)
    end
    if opts.arg then
        cmd = cmd .. pad_str(opts.arg)
    end

    return cmd
end

function M.get_session_info()
    local cmd_str = build_tmux_cmd({cmd = 'display', flags = {"p"}})
    local sstring = lib.trim_newline(run_cmd(cmd_str .. " '#S'"))
    local wstring = lib.trim_newline(run_cmd(cmd_str .. " '#W'"))
    local pstring = lib.trim_newline(run_cmd(cmd_str .. " '#P'"))

    return {session = sstring, window = wstring, panel = pstring}
end

function M.attach_new_pane(cmd)
    local current_tab = api.nvim_get_current_tabpage()
    local current_pane = M.get_tab_terminal_pane()

    -- If the pane is defined but inactive, e.g. if pane crashed, catch here
    if not(M.pane_alive(current_pane)) then
        M.set_tab_terminal_pane(nil)
        current_pane = nil
    end

    if current_pane then
        return M.get_tab_terminal_pane()
    end

    -- Command to start a new terminal and save the id
    local current_info = M.get_session_info()
    local tcmd = build_tmux_cmd(
        {
            cmd = 'splitw', 
            flags = {"h", "F", "P"}, 
            F = "'#{pane_id}'",
            arg = cmd
        }
    )

    local panel_id = run_cmd(tcmd)
    local trimmed_id = panel_id:gsub("%\n$", "")

    M.set_tab_terminal_pane(trimmed_id)

    return panel_id
end

function M.kill_attached_pane()
    local cpane = vim.t.attached_tmux_pane
    vim.t.attached_tmux_pane = nil

    M.kill_tmux_pane(cpane)

    return nil
end

function M.kill_tmux_pane(id)
    local tcmd = build_tmux_cmd({cmd = 'killp', target = id})

    run_cmd(tcmd)
end

function M.toggle_pane(id)
    local win_id = M.get_session_info().window

    if M.pane_alive(id) then
        print("Pane alive")
        print(id)
        for _,l in pairs(M.get_window_panelist(win_id)) do
            print("iterating panes")
            print(l)
            if l == id then
                M.hide_pane(id)
                return nil
            end
        end
        return M.restore_pane(id)
    end
end

function M.hide_pane(id)
    if M.pane_alive(id) then
        if not(M.has_session('tstash')) then
            M.create_session('tstash')
        end
        
        local bcmd = build_tmux_cmd({cmd = 'breakp', flags = {'d'}, source = id, target = 'tstash:'})
        run_cmd(bcmd)
    end
end

function M.restore_pane(id)
    if M.pane_alive(id) then
        local session_info = M.get_session_info()

        local session = session_info.session
        local window = session_info.window

        local tcmd = build_tmux_cmd({cmd = 'joinp', flags = {'d', 'h'}, source = id, target = session .. ':' .. window})

        print(tcmd)
        run_cmd(tcmd)
    end
end

function M.set_tab_terminal_pane(id)
    vim.t.attached_tmux_pane = id

    return id
end

function M.get_tab_terminal_pane()
    return vim.t.attached_tmux_pane
end

function M.get_window_panelist(win)
    local pane_cmd = build_tmux_cmd({cmd = 'lsp', flags = {"F"}, F = "'#{pane_id}'", target = win})
    local panelist = run_cmd(pane_cmd)

    return lib.split_lines(panelist)
end

function M.get_panelist()
    local pane_cmd = build_tmux_cmd({cmd = 'lsp', flags = {"F", "a"}, F = "'#{pane_id}'"})
    local panelist = run_cmd(pane_cmd)

    return lib.split_lines(panelist)
end

function M.has_session(s)
    local scmd = build_tmux_cmd({cmd = 'has', target = s})

    run_cmd(scmd)
    if vim.v.shell_error == 0 then
        return 1
    else
        return nil
    end
end

function M.create_session(s)
    local scmd = build_tmux_cmd({cmd = "new-session", flags = {"d", "s"}, arg = s})

    run_cmd(scmd)
end

function M.pane_alive(id)
    if not(id) then
        return nil
    end

    local panelist = M.get_panelist()


    for _,l in pairs(panelist) do
        if l == id then
            return id
        end
    end

    return nil
end

function pad_str(s) return ' ' .. s end

-- print(M.attach_new_pane('julia'))

-- print(M.has_session(1))
-- print(M.has_session(2))

-- M.hide_pane(vim.t.attached_tmux_pane)
-- M.restore_pane(vim.t.attached_tmux_pane)

return M

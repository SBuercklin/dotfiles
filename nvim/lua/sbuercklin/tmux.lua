local lib = require("sbuercklin.lib")
local run_cmd = vim.fn.system
local api = vim.api
local pad_str = lib.pad_str

-- Builds a tmux command from a table
-- opts should have 'cmd' for the tmux command, 'arg' for any arguments at the end
-- flags are passed in with a flags table, and then the arguments to those flags if needed
--  are specified in the top level table.
--
-- For example, the following table generates a tmux command to split a window to make a new pane
--      to the right of the current pane (-h), echo the new pane id (-F with argument), 
--      not switch to the pane (-d), prints info about the window (-P), and starts julia:
-- {cmd = 'splitw', flags = {'h', 'F', 'P', 'd'}, F = {"'#{pane_id}'"}, cmd = 'julia'}
--
--  `tmux splitw -F '#{pane_id}' -h -P -d `
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
    if opts.arg then
        cmd = cmd .. pad_str(opts.arg)
    end

    return cmd
end

local M = {}

function M.get_session_info()
    local cmd_str = build_tmux_cmd({cmd = 'display', flags = {"p"}})
    local sstring = lib.trim_newline(run_cmd(cmd_str .. " '#{session_id}'"))
    local wstring = lib.trim_newline(run_cmd(cmd_str .. " '#{window_id}'"))
    local pstring = lib.trim_newline(run_cmd(cmd_str .. " '#D'"))

    return {session = sstring, window = wstring, panel = pstring}
end

-- attaches a new pane to the vim instance, but does not focus this pane
--  the pane will need to be toggled to bring it into view in the current instance
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

    local new_id = M.create_pane_cmd('tstash', cmd)
    M.set_tab_terminal_pane(new_id)

    return new_id
end

-- Create a pane in the session s with a cmd
function M.create_pane_cmd(sess, cmd)
    M.ensure_session(sess)
    local tcmd = build_tmux_cmd(
        {
            cmd = 'neww', 
            flags = {"F", "P", "d", "t"}, 
            F = "'#{pane_id}'",
            t = sess .. ':', -- target the session, let tmux pick window
            arg = cmd
        }
    )

    local panel_id = run_cmd(tcmd)
    local trimmed_id = panel_id:gsub("%\n$", "")

    return trimmed_id
end

function M.kill_attached_pane()
    local cpane = vim.t.attached_tmux_pane
    vim.t.attached_tmux_pane = nil

    M.kill_tmux_pane(cpane)

    return nil
end

function M.kill_tmux_pane(id)
    local tcmd = build_tmux_cmd({cmd = 'killp', flags = {'t'}, t = id})

    run_cmd(tcmd)
end

-- Toggles the pane with a given id on the RHS of the window
function M.toggle_pane(id)
    local win_id = M.get_session_info().window

    if M.pane_alive(id) then
        for _,l in pairs(M.get_window_panelist(win_id)) do
            if l == id then
                M.hide_pane(id)
                return nil
            end
        end
        return M.restore_pane(id)
    end
end

function M.toggle_attached_pane() M.toggle_pane(vim.t.attached_tmux_pane) end

-- Hides the pane with the given id in the supplied session s, default to tstash
function M.hide_pane(id, s)
    if not(s) then
        s = 'tstash'
    end
    if M.pane_alive(id) then
        M.ensure_session(s)
        
        local bcmd = build_tmux_cmd({cmd = 'breakp', flags = {'d', 't', 's'}, s = id, t = s .. ':'})
        run_cmd(bcmd)
    end
end

-- Restores the pane with the given id on the RHS of the current window
function M.restore_pane(id)
    if M.pane_alive(id) then
        local session_info = M.get_session_info()

        local session = session_info.session
        local window = session_info.window

        local tcmd = build_tmux_cmd({cmd = 'joinp', flags = {'d', 'h', 's', 't'}, s = id, t = ':' .. window})

        run_cmd(tcmd)
    end
end

function M.set_tab_terminal_pane(id)
    vim.t.attached_tmux_pane = id
    return id
end

function M.get_tab_terminal_pane(i)
    if i then 
        return vim.t[i].attached_tmux_pane
    else
        return vim.t.attached_tmux_pane
    end
end

function M.detach_pane(sess)
    local attached_pane = M.get_tab_terminal_pane()
    if not(attached_pane) then
        return nil
    end

    if not(sess) then
        sess = 'tstash'
    end

    M.hide_pane(attached_pane, sess)
    M.set_tab_terminal_pane(nil)
end

function M.attach_existing_pane(id)
    local panelist = M.get_panelist()

    for _,l in pairs(panelist) do
        if l == id then
            local acmd = build_tmux_cmd({cmd = 'joinp', flags = {'h', 'd', 's', 't'}, s = id, t = ':'})
            run_cmd(acmd)

            vim.t.attached_tmux_pane = id
        end
    end
end

-- Returns a list of the panes in the given tmux window
function M.get_window_panelist(win)
    local pane_cmd = build_tmux_cmd({cmd = 'lsp', flags = {"F", 't'}, F = "'#{pane_id}'", t = win})
    local panelist = run_cmd(pane_cmd)

    return lib.split_lines(panelist)
end

-- Returns a list of all panes across all tmux sessions
function M.get_panelist()
    local pane_cmd = build_tmux_cmd({cmd = 'lsp', flags = {"F", "a"}, F = "'#{pane_id}'"})
    local panelist = run_cmd(pane_cmd)

    return lib.split_lines(panelist)
end

function M.get_windowlist(sess)
    if not(sess) then
        sess = 'tstash'
    end
    local wcmd = build_tmux_cmd({cmd = 'lsp', flags = {'F', 's', 't'}, F = "'#{pane_id}'", t = sess})

    local wlist = run_cmd(wcmd)

    return lib.split_lines(wlist)
end

-- Check to see if a pane with the given ID is alive
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

-- check to see if a session named s exists
function M.has_session(s)
    local scmd = build_tmux_cmd({cmd = 'has', flags = {'t'}, t = s})

    run_cmd(scmd)
    if vim.v.shell_error == 0 then
        return 1
    else
        return nil
    end
end

-- create a session named s
function M.create_session(s)
    local scmd = build_tmux_cmd({cmd = "new-session", flags = {"d", "s"}, arg = s})

    run_cmd(scmd)
end

function M.ensure_session(s)
    if M.has_session(s) then
        return 1
    else
        return M.create_session(s)
    end
end
  
-- TODO: This seems to not kill active panes in some cases?
vim.api.nvim_create_augroup('TmuxAttachedPane', {clear = true})
vim.api.nvim_create_autocmd(
    'VimLeavePre', { callback = function(ev)
        local numtabs = vim.fn.tabpagenr('$')
        for tabnr=1,numtabs do
            local cpane = M.get_tab_terminal_pane(tabnr)
            if M.pane_alive(cpane) then
                M.kill_tmux_pane(cpane)
            end
        end
    end,
    group = 'TmuxAttachedPane'
    }
)

return M

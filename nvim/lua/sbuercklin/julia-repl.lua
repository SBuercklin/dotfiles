local tmux = require("sbuercklin.tmux")

-- TODO: Try ToggleTerm for this:  https://github.com/akinsho/toggleterm.nvim

-- Assuming you're in a terminal in normal mode, enter terminal mode, start julia, and return
-- to normal mode
function startJuliaCmd(project, startup)
    local execute = 'using Revise, Infiltrator, Pkg'
    if startup ~= nil then
        execute = execute .. '; include(\"' .. startup .. '\");'
    end

    local extra_args = ''
    if project ~= nil then
        extra_args = extra_args .. '--project=' .. project .. ' '
    end

    local start_cmd = 'julia ' .. '-i -e \'' .. execute .. '\' ' .. extra_args

    -- print(start_cmd)
    -- vim.cmd('terminal ' .. start_cmd)

    return start_cmd
end

-- Just go to the rightmost window, split in half, terminal in bottm, open terminal with cmd
function createJuliaREPL(project, startup)
    local jcmd = startJuliaCmd(project, startup) 

    local id = tmux.attach_new_pane(jcmd)

    return id
end

function findProjectTOML()
    return vim.fs.find('Project.toml',  { upward = true })[1]
end

function findStartupJL()
    return vim.fs.find('startup.jl_',  { upward = true })[1]
end

function activeJuliaREPL()
    return vim.t.julia_repl_job_id
end

function sendJulia(str)
    local pane_tgt = tmux.get_tab_terminal_pane()
    vim.b.slime_config = {socket_name = "default", target_pane = pane_tgt }

    vim.cmd.SlimeSend1(str)
end

function envJuliaStatus()
     sendJulia('Pkg.status()')
end

function envJuliaTest()
    sendJulia('Pkg.test()')
end

function toggleJuliaREPL()
    tmux.toggle_attached_pane()
end

function killJuliaREPL()
    sendJulia('exit()')
    local buf_id = vim.t.julia_repl_buf_id

    vim.api.nvim_buf_delete(buf_id, { force = true })
end

function sendJuliaLine()
    sendJulia(vim.api.nvim_get_current_line())
end

function sendJuliaVisual()
    -- Yank visual selection into v register
    -- Reference: https://www.reddit.com/r/neovim/comments/oo97pq/how_to_get_the_visual_selection_range/
    vim.cmd('noau normal! "vy"')
    local contents = vim.fn.getreg('"v')
    sendJulia(contents)
end

vim.api.nvim_create_autocmd(
    'BufDelete', { callback = function(ev)
        if ev['buf'] == vim.t.julia_repl_buf_id then
            vim.t.julia_repl_job_id = nil
            vim.t.julia_repl_buf_id = nil
            print("Deleted Julia REPL from Tab")
        end
    end
    }
)

-- Keymaps for interacting with REPL
vim.keymap.set('n', '<leader>jr', createJuliaREPL)
vim.keymap.set('n', '<leader>js', envJuliaStatus)
vim.keymap.set('n', '<leader>jt', envJuliaTest)
vim.keymap.set('n', '<leader>jp', toggleJuliaREPL)
vim.keymap.set('n', '<leader>jq', tmux.kill_attached_pane)
vim.keymap.set('n', '<leader>jd', tmux.detach_pane)
vim.keymap.set('n', '<C-m>', sendJuliaLine)
vim.keymap.set('v', '<C-m>', sendJuliaVisual)

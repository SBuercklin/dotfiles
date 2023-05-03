-- Assuming you're in a terminal in normal mode, enter terminal mode, start julia, and return
-- to normal mode
function startJulia(project, startup)
    local execute = 'using Revise, Infiltrator, Pkg'
    if startup ~= nil then
        execute = execute .. '; include(\"' .. startup .. '\");'
    end
    
    local extra_args = ''
    if project ~= nil then
        extra_args = extra_args .. '--project=' .. project .. ' '
    end

    local start_cmd = 'julia ' .. '-i -e \'' .. execute .. '\' ' .. extra_args

    print(start_cmd)
    vim.cmd('terminal ' .. start_cmd)
end

-- Just go to the rightmost window, split in half, terminal in bottm, open terminal with cmd
function createJuliaREPL(project, startup)
    local termbuf = vim.api.nvim_create_buf(true, true)

    vim.api.nvim_buf_call(termbuf, function() startJulia(project, startup) end)

    return termbuf
end

function tabJuliaREPL()
    if vim.t.julia_repl_job_id == nil then
        local repl_buf_id = createJuliaREPL(findProjectTOML(), findStartupJL())

        local repl_job_id = vim.b[repl_buf_id].terminal_job_id
        vim.t.julia_repl_job_id = repl_job_id
        vim.t.julia_repl_buf_id = repl_buf_id
    else
        print("Already opened Julia REPL")
    end
end

function findProjectTOML()
    return vim.fs.find('Project.toml',  { upward = true })[1]
end

function findStartupJL()
    return vim.fs.find('startup.jl_',  { upward = true })[1]
end

function envJuliaStatus()
    job_id = activeJuliaREPL()
    if job_id ~= nil then
        vim.api.nvim_chan_send(job_id, 'Pkg.status()\n')
    end
end

function envJuliaTest()
    job_id = activeJuliaREPL()
    if job_id ~= nil then
        vim.api.nvim_chan_send(job_id, 'Pkg.test()\n')
    end
end

function activeJuliaREPL()
    return vim.t.julia_repl_job_id
end

function toggleJuliaREPL()
    local current_buf_id = vim.api.nvim_get_current_buf()
    local repl_id = vim.t.julia_repl_buf_id
    local toggle_id = vim.w.julia_repl_toggle_buf

    if (current_buf_id ~= repl_id) and (repl_id ~= nil) then
        vim.w.julia_repl_toggle_buf = current_buf_id
        vim.api.nvim_set_current_buf(repl_id)
    elseif (current_buf_id == repl_id) and (toggle_id ~= nil) then
        vim.api.nvim_set_current_buf(toggle_id)
        vim.w.julia_repl_toggle_buf = nil
    end
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
vim.keymap.set('n', '<leader>jr', tabJuliaREPL)
vim.keymap.set('n', '<leader>js', envJuliaStatus)
vim.keymap.set('n', '<leader>jt', envJuliaTest)
vim.keymap.set('n', '<leader>jp', toggleJuliaREPL)

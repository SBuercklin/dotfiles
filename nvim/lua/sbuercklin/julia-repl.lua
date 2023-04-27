-- Assuming you're in a terminal in normal mode, enter terminal mode, start julia, and return
-- to normal mode
function startJulia(project)
    local execute = 'using Revise, Infiltrator'
    local extra_args = ''
    if project ~= nil then
        extra_args = extra_args .. '--project=' .. project .. ' '
    end
    local start_cmd = 'julia ' .. '-i -e \"' .. execute .. '\" ' .. extra_args

    vim.cmd('terminal ' .. start_cmd)

end

-- Just go to the rightmost window, split in half, terminal in bottm, open terminal with cmd
function createJuliaREPL(project)
    local startwin = vim.api.nvim_get_current_win()
    vim.cmd('wincmd 100 l') -- Go right as far as you can

    vim.cmd('split')
    vim.cmd('wincmd 1 j')

    local termbuf = vim.fn.bufnr()

    startJulia(project)

    vim.api.nvim_set_current_win(startwin)

    return termbuf
end

function tabJuliaREPL()
    if vim.t.julia_repl_buffer == nil then
        local repl_buf_id = createJuliaREPL(findProjectTOML())

        vim.t.julia_repl_buffer = repl_buf_id
    else
        print("Already opened Julia REPL")
    end
end

function findProjectTOML()
    return vim.fs.find('Project.toml',  { upward = true })[1]
end

-- Keymap to start the repl
vim.keymap.set('n', '<leader>jr', tabJuliaREPL)

vim.api.nvim_create_autocmd(
    'BufDelete', { callback = function(ev)
        if ev['buf'] == vim.t.julia_repl_buffer then
            vim.t.julia_repl_buffer = nil
            print("Deleted Julia REPL from Tab")
        end
    end
    }
)

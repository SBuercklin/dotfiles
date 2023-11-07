local tmux = require("sbuercklin.tmux")
local slime = require("sbuercklin.slime")

function startJuliaCmd(project, startup)
    local execute = 'using Revise, Infiltrator, Pkg, TestEnv'
    if startup ~= nil then
        execute = execute .. '; include(\"' .. startup .. '\");'
    end

    local extra_args = ''
    if project ~= nil then
        extra_args = extra_args .. '--project=' .. project .. ' '
    end

    local start_cmd = 'julia ' .. extra_args .. '-i -e \'' .. execute .. '\' '
    return start_cmd
end

function findProjectTOML()
    return vim.fs.find('Project.toml',  { upward = true })[1]
end

function findStartupJL()
    return vim.fs.find('startup.jl_',  { upward = true })[1]
end

vim.api.nvim_create_autocmd(
    "BufEnter",
    {
        pattern = {"*.jl"},
        callback = function(ev)
            vim.keymap.set(
                'n', 
                '<leader>jr', 
                function() tmux.attach_new_pane(startJuliaCmd(findProjectTOML(), findStartupJL())) end, 
                {buffer = ev['buf']}
            )
            if slime.slime_active() then 
                vim.keymap.set(
                    'n', '<leader>js', function() slime.send_to_terminal('Pkg.status()') end, {buffer = ev['buf']}
                )
                vim.keymap.set(
                    'n', '<leader>jt', function() slime.send_to_terminal('Pkg.test()') end, {buffer = ev['buf']}
                )
                vim.keymap.set(
                    'n', '<leader>ja', function() slime.send_to_terminal('TestEnv.activate()') end, {buffer = ev['buf']}
                )
            end
        end
    }
)

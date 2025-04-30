-- Toggle diagnostics command
local toggle_diagnostics = function(_t)
    if vim.diagnostic.is_enabled() then
        print("Diagnostics disabled")
        vim.diagnostic.enable(false)
    else
        print("Diagnostics enabled")
        vim.diagnostic.enable()
    end
end
vim.api.nvim_create_user_command("ToggleDiagnostic", toggle_diagnostics, {})

-- Copies the complete path to the currently active buffer into the global clipboard
local copy_filepath = function()
    vim.cmd [[ let @+ = expand("%:p") ]]
end
vim.api.nvim_create_user_command("CopyFilepath", copy_filepath,
    { desc = "Copies the current buffer filepath to the global clipboard" })

-- Used for defining a usercommand for use with vim-fugitive and :GBrowse
-- See: https://vi.stackexchange.com/questions/38447/vim-fugitive-netrw-not-found-define-your-own-browse-to-use-gbrowse
vim.api.nvim_create_user_command(
    'Browse',
    function(opts)
        local os_str = vim.loop.os_uname().sysname
        local open_cmd = 'xdg-open'
        if os_str == 'Darwin' then
            open_cmd = 'open'
        end
        vim.fn.system { open_cmd, opts.fargs[1] }
    end,
    {
        nargs = 1,
        desc = '"Opens" the provided argument using the system "open" command in an explorer of some type'
    }
)

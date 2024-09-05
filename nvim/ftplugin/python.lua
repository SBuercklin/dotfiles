vim.api.nvim_create_augroup("SamPython", { clear = true })

vim.api.nvim_create_autocmd(
    "BufEnter",
    {
        pattern = { "*.py" },
        callback = function(ev)
            vim.opt_local.foldmethod = "indent"
        end,
        group = "SamPython"
    }
)

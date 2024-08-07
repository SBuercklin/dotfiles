local M = {}

M.setup = function(opts)
    vim.api.nvim_create_autocmd(
        "BufEnter",
        {
            pattern = {"*.py"},
            callback = function(ev)
                vim.opt_local.foldmethod = "indent"
            end
        }
    )
end

return M

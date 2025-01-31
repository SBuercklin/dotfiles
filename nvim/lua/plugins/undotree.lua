return {
    'mbbill/undotree',     -- Tree-view of undo history
    keys = {
        { "<leader>u", vim.cmd.UndotreeToggle, mode = "n", "Toggled undo-tree" },
    },
    config = function()
        -- Focuses the undo tree when it's opened
        vim.api.nvim_set_var("undotree_SetFocusWhenToggle", 1)
        vim.api.nvim_set_var("undotree_WindowLayout", 2)
    end
}

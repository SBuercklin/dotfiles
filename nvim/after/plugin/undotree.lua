vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Focuses the undo tree when it's opened
vim.api.nvim_set_var("undotree_SetFocusWhenToggle", 1)

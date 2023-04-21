vim.keymap.set("n", "<C-_>", vim.cmd.Commentary)
vim.keymap.set("i", "<C-_>", vim.cmd.Commentary)

-- TODO: Find a better mapping for this that uses lua command
vim.keymap.set("v", "<C-_>", ':Commentary<CR>gv')

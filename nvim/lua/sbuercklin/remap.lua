vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Window movement remaps
--     Move between windows
vim.keymap.set("n", "<A-h>", "<C-w>h")
vim.keymap.set("n", "<A-j>", "<C-w>j")
vim.keymap.set("n", "<A-k>", "<C-w>k")
vim.keymap.set("n", "<A-l>", "<C-w>l")

-- Insert mode exit with 
vim.keymap.set("i", "jj", "<Esc>", {silent = true})

-- Switch Buffers
vim.keymap.set("n", "<leader>bn", vim.cmd['bnext'])
vim.keymap.set("n", "<leader>bp", vim.cmd['bprevious'])

-- Tab/Shift-Tab to indent
vim.keymap.set("n", "<Tab>", '>>')
vim.keymap.set("n", "<S-Tab>", '<<')
vim.keymap.set("v", "<Tab>", '>gv')
vim.keymap.set("v", "<S-Tab>", '<gv')

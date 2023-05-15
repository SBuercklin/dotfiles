local lib = require("sbuercklin.lib")

vim.g.mapleader = " "

if lib.isModuleAvailable('nvim-tree') then
    vim.keymap.set("n", "<leader>e", vim.cmd.NvimTreeToggle)
else
    vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
end

-- Window movement remaps
--     Move between windows
vim.keymap.set("n", "<A-h>", "<C-w>h")
vim.keymap.set("n", "<A-j>", "<C-w>j")
vim.keymap.set("n", "<A-k>", "<C-w>k")
vim.keymap.set("n", "<A-l>", "<C-w>l")

-- Insert mode exit with 
vim.keymap.set("i", "jj", "<Esc>", {silent = true})
vim.keymap.set("t", "jj", "<C-\\><C-n>", {silent = true})
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", {silent = true})

-- Switch Buffers, Tabs
vim.keymap.set("n", "<leader>bn", vim.cmd['bnext'])
vim.keymap.set("n", "<leader>bp", vim.cmd['bprevious'])
vim.keymap.set("n", "<leader>tn", vim.cmd['tabnext'])
vim.keymap.set("n", "<leader>tp", vim.cmd['tabprevious'])

-- Tab/Shift-Tab to indent
vim.keymap.set("n", "<Tab>", '>>')
vim.keymap.set("n", "<S-Tab>", '<<')
vim.keymap.set("v", "<Tab>", '>gv')
vim.keymap.set("v", "<S-Tab>", '<gv')

-- C-l clashes with tmux window movements
vim.keymap.set("n", "<leader>cl", vim.cmd['noh'])

-- Toggle relative line numbers
vim.keymap.set("n", "<leader>tr", function() vim.opt.rnu = not vim.opt.rnu:get() end)

-- Center cursor on C-u, C-d, n, N
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- System clipboard interactions, indenting
for _,mode in ipairs({"n", "v"}) do
    -- Copy
    vim.keymap.set(mode, "<leader>y", "\"+y")
    -- Cut
    vim.keymap.set(mode, "<leader>d", "\"+d")
    -- Paste
    vim.keymap.set(mode, "<leader>p", "\"+p")
    vim.keymap.set(mode, "<leader>P", "\"+P")
end

-- If gf is over a file that doesn't exist, create it
vim.keymap.set("n", "gf", function()
    vim.cmd { cmd = 'e', args = { '<cfile>' } }
end)

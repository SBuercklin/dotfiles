local lib = require("samlib")

if lib.isModuleAvailable('nvim-tree') then
    vim.keymap.set("n", "<leader>e", vim.cmd.NvimTreeToggle)
else
    vim.keymap.set("n", "<leader>e", vim.cmd.Ex)
end

-- Window movement remaps
--     Move between windows
if not (lib.isModuleAvailable('tmux')) then
    --     These are superseded by tmux.nvim configs
    vim.keymap.set("n", "<A-h>", "<C-w>h")
    vim.keymap.set("n", "<A-j>", "<C-w>j")
    vim.keymap.set("n", "<A-k>", "<C-w>k")
    vim.keymap.set("n", "<A-l>", "<C-w>l")
end

-- Insert mode exit with
vim.keymap.set("i", "jj", "<Esc>", { silent = true })
vim.keymap.set("t", "jj", "<C-\\><C-n>", { silent = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })

-- Switch Buffers, Tabs
vim.keymap.set("n", "<leader>bn", vim.cmd['bnext'])
vim.keymap.set("n", "<leader>bp", vim.cmd['bprevious'])
vim.keymap.set("n", "<leader>tn", vim.cmd['tabnext'])
vim.keymap.set("n", "<leader>tp", vim.cmd['tabprevious'])

-- Tab/Shift-Tab to indent
vim.keymap.set("n", ">", '>>')
vim.keymap.set("n", "<", '<<')
vim.keymap.set("v", ">", '>gv')
vim.keymap.set("v", "<", '<gv')

-- Toggle relative line numbers
vim.keymap.set("n", "<leader>tr", function() vim.opt.rnu = not vim.opt.rnu:get() end)

-- Center cursor on C-u, C-d, n, N
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- System clipboard interactions, indenting
for _, mode in ipairs({ "n", "v" }) do
    -- Copy
    vim.keymap.set(mode, "<leader>y", "\"+y")
    -- Cut
    vim.keymap.set(mode, "<leader>d", "\"+d")
    -- Paste
    vim.keymap.set(mode, "<leader>p", "\"+p")
    vim.keymap.set(mode, "<leader>P", "\"+P")
end

-- Toggle spellcheck
vim.keymap.set("n", "<leader>zt", function() vim.cmd.set({ args = { 'spell!', 'spelllang=en_us' } }) end)

local function toggle_quickfix()
    local windows = vim.fn.getwininfo()
    for _, win in pairs(windows) do
        if win["quickfix"] == 1 then
            vim.cmd.cclose()
            return
        end
    end
    vim.cmd.copen()
end

vim.keymap.set('n', '<Leader>tq', toggle_quickfix, { desc = "Toggle Quickfix Window" })

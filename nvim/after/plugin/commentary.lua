local lib = require("sbuercklin.lib")

vim.keymap.set("n", "<C-_>", vim.cmd.Commentary)
vim.keymap.set("i", "<C-_>", vim.cmd.Commentary)

-- Enable visual mode by getting the lines and then pass to commentary
function comment_visual()
    local strt = math.min(vim.fn.line("v"), vim.fn.line("."))
    local stp = math.max(vim.fn.line("v"), vim.fn.line("."))

    vim.cmd(tostring(strt) .. "," .. tostring(stp) .. "Commentary")
end

vim.keymap.set("v", "<C-_>", comment_visual)

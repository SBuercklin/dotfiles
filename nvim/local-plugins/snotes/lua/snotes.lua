local notes = require("notes")
local todo = require("todo")

local M = {}

M.setup = function (opts)
    vim.keymap.set('n', '<leader>nn', notes.get_daily_note)

    -- We use ripgrep to do the TODO parsing.
    -- TODO: rewrite with normal grep?
    if vim.fn.executable('rg') then
        vim.keymap.set('n', '<leader>nt', todo.show_todo_list)
    end
end

M.notes = notes
M.todo = todo

return M

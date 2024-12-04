local notes = require("notes")

local M = {}

M.setup = function(opts)
    vim.keymap.set('n', '<leader>nn', notes.get_daily_note)
end

M.notes = notes

return M

local api = vim.api
local fn = vim.fn
local lib = require("samlib")

local M = {}

local sam_note_buf_augroup = "SamNoteBuffer"
vim.api.nvim_create_augroup(sam_note_buf_augroup, { clear = true })

-- TODO:
-- 1. Add ability to check the local dir for a notefile

local month_map = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October",
    "November", "December" }

function M.get_note_dir()
    return lib.get_normalized_home() .. ".sam-notes/"
end

function M.get_note_title()
    local dt = os.date('*t')

    local __month = dt['month']
    local month_name = month_map[__month]
    local month = tostring(__month)
    local year = tostring(dt['year'])
    local day = tostring(dt['day'])

    if month:len() == 1 then
        month = '0' .. month
    end
    if day:len() == 1 then
        day = '0' .. day
    end

    local fname = year .. "-" .. month .. "-" .. day
    local title = month_name .. " " .. day .. ", " .. year .. " (" .. fname .. ")"

    return fname, title
end

function M.open_note(note_name, note_list, prev_b)
    local note_dir = M.get_note_dir()

    vim.cmd('e ' .. note_dir .. note_name)

    local b = api.nvim_get_current_buf()

    vim.keymap.set('n', '<leader>np', function() M.get_prev_note(note_list, note_name, b) end, { buffer = b })
    vim.keymap.set('n', '<leader>nn', function() M.get_next_note(note_list, note_name, b) end, { buffer = b })

    -- vim.api.nvim_create_autocmd("BufLeave", {
    --     callback = function(ev)
    --         if not vim.api.nvim_get_option_value("modified", { buf = b }) then
    --             vim.api.nvim_buf_delete(b, {})
    --         end
    --     end,
    --     group = sam_note_buf_augroup,
    --     buffer = b,
    --     desc = "Closing a buffer on leave if unmodified",
    -- })

    return b
end

function M.get_daily_note()
    -- lib.open_win()

    local note_dir = M.get_note_dir()
    local fname, title = M.get_note_title()
    local note_list = lib.get_sorted_files(note_dir)

    local note_fname = fname .. ".md"

    local b = M.open_note(note_fname, note_list, nil)

    local oneline = fn.getbufline(b, 1)[1]
    if oneline:len() == 0 then
        fn.setbufline(b, 1, "# Daily Note " .. title)
    end
end

function M.get_prev_note(notelist, cnote, prev_b)
    local idx = lib.find_in_table(notelist, cnote)
    if idx and idx > 1 then
        local next_note = notelist[idx - 1]
        M.open_note(next_note, notelist, prev_b)
    end
end

function M.get_next_note(notelist, cnote, prev_b)
    local idx = lib.find_in_table(notelist, cnote)
    if idx and idx < (#notelist) then
        local next_note = notelist[idx + 1]
        M.open_note(next_note, notelist, prev_b)
    end
end

return M

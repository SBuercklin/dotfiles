local api = vim.api
local fn = vim.fn
local math = require("math")

local M = {}

function M.get_note_dir()
    return "~/.sam-notes/"
end

function M.open_win()
    local N = 10 
    local width = math.floor(fn.winwidth(0) / N)
    local height = math.floor(fn.winheight(0) / N)

    local w = api.nvim_open_win(0, true, {relative='win', row=height, col=width, width=width*(N-2), height=height*(N-2), border="double"})

    vim.wo[w].nu = false
    vim.wo[w].rnu = false
end

function M.get_note_title()
    local dt = os.date('*t')
    
    local year = tostring(dt['year'])
    local month = tostring(dt['month'])
    local day = tostring(dt['day'])

    if month:len() == 1 then
        month = '0' .. month
    end
    if day:len() == 1 then
        day = '0' .. day
    end
    

    local title = year .. "-" .. month .. "-" .. day 

    return title
end

function M.get_daily_note()
    M.open_win()

    local note_dir = M.get_note_dir()
    local title = M.get_note_title()

    vim.cmd('e ' .. note_dir .. title .. ".md")

    local b = api.nvim_get_current_buf()

    local oneline = fn.getbufoneline(b, 1)
    if oneline:len() == 0 then
        fn.setbufline(b, 1, "# " .. title .. " Daily Note")
    end
end

vim.keymap.set('n', '<leader>nn', M.get_daily_note)

return M

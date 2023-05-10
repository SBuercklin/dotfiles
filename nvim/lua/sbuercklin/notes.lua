local api = vim.api
local fn = vim.fn
local math = require("math")
local lib = require("sbuercklin.lib")

local M = {}

local month_map = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}

function M.get_note_dir()
    return lib.get_normalized_home() .. ".sam-notes"
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

function M.get_daily_note()
    M.open_win()

    local note_dir = M.get_note_dir()
    local fname, title = M.get_note_title()

    print(title .. " " .. fname)

    vim.cmd('e ' .. note_dir .. fname .. ".md")

    local b = api.nvim_get_current_buf()

    local oneline = fn.getbufline(b, 1)[1]
    if oneline:len() == 0 then
        fn.setbufline(b, 1, "# Daily Note " .. title)
    end
end

vim.keymap.set('n', '<leader>nn', M.get_daily_note)

return M

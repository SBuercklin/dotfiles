-- We define the slime module here so we can optinally add keymaps in other files
local lib = require("sbuercklin.lib")
local tmux = require("sbuercklin.tmux")

local M = {}

function M.slime_active() 
    return vim.g.loaded_slime
end

return M

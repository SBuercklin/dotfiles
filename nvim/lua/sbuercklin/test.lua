-- Prints all of the files in the  directory
print(vim.fn.getcwd())
print(vim.loop.os_homedir())
print(vim.fs.dirname(vim.loop.os_homedir()))
-- for i in vim.fs.dir(vim.fn.getcwd()) do
--     print(i)
-- end


local test_dirs = vim.fs.find(
    '.vimrc', 
    { upward = true, stop = vim.fs.dirname(vim.loop.os_homedir()), path = vim.fn.getcwd() }
    )

for k,v in pairs(test_dirs) do 
    print(v)
end

local ts = require("nvim-treesitter.ts_utils")
local lib = require("sbuercklin.lib")

function print_node()
    print("activated")
    local node = ts.get_node_at_cursor()
    print(lib.dump({lib.dump(ts.get_node_text(node)), lib.dump(ts.get_node_text(node:parent()))}))
    -- print(lib.dump(node))
end

vim.keymap.set("n", "<C-u>", print_node)

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

local ts = require("vim.treesitter")
local lib = require("sbuercklin.lib")

function print_node()
    print("activated")
    local node = ts.get_node()
    print(lib.dump({lib.dump(ts.get_node_text(node, 0)), lib.dump(ts.get_node_text(node:parent(), 0))}))
    -- print(lib.dump(node))
end

-- vim.keymap.set("n", "<C-u>", print_node)

function test()
    local cur = vim.fn.getcurpos()
    vim.cmd.normal("^")

    local node = ts.get_node()
    local data = {text = ts.get_node_text(node, 0), type = node:type(), prt = node:parent():type()}
    print(lib.dump(data))

    vim.fn.setpos('.', cur)
end

function test2()
    local cur = vim.fn.getcurpos()
    vim.cmd.normal("^")

    local node = ts.get_node()
    print(node:type() == "function_definition")

    vim.fn.setpos('.', cur)
end

vim.keymap.set("n", "<C-u>", test)
vim.keymap.set("n", "<C-t>", test2)

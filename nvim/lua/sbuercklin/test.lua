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

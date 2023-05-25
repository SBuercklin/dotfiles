vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
vim.keymap.set("n", "<leader>gb", function() vim.cmd({ cmd = 'Git', args = { 'blame' } }) end)

vim.keymap.set("n", "<leader>glg", 
    function() 
        vim.cmd({ cmd = 'Git',  args = { 'log --graph --oneline' } }) 
    end
    )
vim.keymap.set("n", "<leader>gll", 
    function() 
        vim.cmd({ cmd = 'Git',  args = { 'log --graph --oneline --all' } }) 
    end
    )

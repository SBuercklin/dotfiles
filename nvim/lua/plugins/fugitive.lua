return {
    'tpope/vim-fugitive',
    dependencies = {
        'shumphrey/fugitive-gitlab.vim',
    },
    lazy = false,
    keys = {
        {
            "<leader>gs",
            vim.cmd['Git'],
            mode = "n",
            desc = "git status in nvim"
        },
        {
            "<leader>gb",
            function() vim.cmd({ cmd = 'Git', args = { 'blame' } }) end,
            mode = "n",
            desc = "git blame for current buffer"
        },
        {
            "<leader>glg",
            function() vim.cmd({ cmd = 'Git', args = { 'log --graph --oneline' } }) end,
            mode = "n",
            desc = "git log graph, current branch"
        },
        {
            "<leader>gll",
            function() vim.cmd({ cmd = 'Git', args = { 'log --graph --oneline --all' } }) end,
            mode = "n",
            desc = "git log graph"
        },
    }
}

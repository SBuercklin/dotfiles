require("sbuercklin.packer")
local lib = require("sbuercklin.lib")

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Generic remaps go here
require("sbuercklin.remap")
require("sbuercklin.notes")
require("sbuercklin.julia-repl")

if vim.fn.executable('rg') then
    vim.opt.grepprg = 'rg -n --no-heading'

    -- We use ripgrep to do the TODO parsing.
    -- TODO: rewrite with normal grep?
    require("sbuercklin.todo")
end

-- Sets the colorscheme 
vim.cmd [[colorscheme nightfly]]

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- Only do case-senstive search if capitalization is included
--  override with \C in search string to make case sensitive
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- Don't use swapfiles, but store the undos in a dir
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.incsearch = true

-- Makes sure you have at least N lines above/below cursor when you scroll
vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"

-- Don't automatically add comments with newlines
vim.api.nvim_create_autocmd(
    'BufEnter', { callback = function(ev)
        vim.opt.formatoptions:remove { "c", "r", "o" }
    end
    }
)

-- Don't save terminals in sessions
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize"

-- Code Folding, and a function below it to create the autocommands to open folds on enter
-- ref: https://www.jmaguire.tech/posts/treesitter_folding/
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

vim.api.nvim_create_autocmd(
    'BufReadPost', { callback = function(ev)
        vim.fn.feedkeys("zR")
    end
    }
)

-- Open help in a vertical split to the right
vim.api.nvim_create_autocmd("BufWinEnter", {
    group = vim.api.nvim_create_augroup("help_window_right", {}),
    pattern = { "*.txt" },
    callback = function()
        if vim.o.filetype == 'help' then vim.cmd.wincmd("L") end
    end
})

-- By default let subsitutions replace all, rather than just the first on a line
-- See: `:help :substitute` and look at the `g` flag description
vim.opt.gdefault = true

-- used for gitgutter
vim.cmd.set('updatetime=100')

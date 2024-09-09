vim.g.mapleader = " "

require("sbuercklin.lazy")

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- Generic remaps go here
require("sbuercklin.remap")

-- Use ripgrep instead of grep if available
if vim.fn.executable('rg') then
    vim.opt.grepprg = 'rg -n --no-heading'
end

-- Sets the colorscheme
vim.cmd [[colorscheme nightfly]]

-- Relative line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- tab configuration
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

-- Put markers at the 90th, 120th columns
vim.opt.colorcolumn = { 90, 120 }

-- Only do case-senstive search if capitalization is included
--  override with \C in search string to make case sensitive
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- Don't use swapfiles, but store the undos in a dir
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Show highlight/matches as you type with /seearches
vim.opt.incsearch = true

-- Makes sure you have at least N lines above/below cursor when you scroll
vim.opt.scrolloff = 4

-- enable the signcolumn, usually we use this for git indications
vim.opt.signcolumn = "yes"

-- Don't automatically add comments with newlines
vim.api.nvim_create_autocmd(
    'BufEnter', {
        callback = function(ev)
            vim.opt.formatoptions:remove { "c", "r", "o" }
        end
    }
)

-- Don't save terminals in sessions
vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize"

-- Code Folding, and a function below it to create the autocommands to open folds on enter
-- ref: https://www.jmaguire.tech/posts/treesitter_folding/
-- vim.opt.foldmethod = "syntax"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- Open all folds when you open a buffer for the first time
vim.api.nvim_create_autocmd(
    'BufReadPost', {
        callback = function(ev)
            vim.fn.feedkeys("zR")
        end
    }
)

-- Helps address really large files where syntax folding can cause hangs
vim.api.nvim_create_autocmd(
    'BufReadPost', {
        callback = function(ev)
            -- If a buffer exceeds 10 kB, assume we fold by indentation
            --  Note: This saves us from really long startup times for enormous files
            if vim.fn.wordcount()["bytes"] > 100000 then
                vim.opt_local.foldmethod = "indent"
            else
                vim.opt_local.foldmethod = "syntax"
            end
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

-- Toggle diagnostics command
local toggle_diagnostics = function(_t)
    if vim.diagnostic.is_enabled() then
        print("Diagnostics disabled")
        vim.diagnostic.enable(false)
    else
        print("Diagnostics enabled")
        vim.diagnostic.enable()
    end
end
vim.api.nvim_create_user_command("ToggleDiagnostic", toggle_diagnostics, {})

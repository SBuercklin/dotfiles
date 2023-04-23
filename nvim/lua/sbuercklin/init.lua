-- Remaps go here
require("sbuercklin.remap")

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

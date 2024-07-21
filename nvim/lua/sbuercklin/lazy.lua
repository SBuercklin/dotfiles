local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)


opts = {}

local plugins = {
    -----------------------------------------
    -- Basic usage
    -----------------------------------------
    -- UI/modal niceties, like undotree, bettery quick-fix, nvim-tree, git interaction
    require "sbuercklin/configs/ui",

    -- Text editing niceties (comment commands, autopairs, split/join, surround)
    require "sbuercklin/configs/editing",

    -- Telescope picker, generally <leader>f_ where _ is some key to open a picker
    require "sbuercklin/configs/telescope",

    -----------------------------------------
    -- Integrations
    -----------------------------------------
    -- high level tmux integration, send-to-terminal target using slime
    require "sbuercklin/configs/tmux",
    require "sbuercklin/configs/vim-slime",

    -----------------------------------------
    -- LSP autocomplete, languages
    -----------------------------------------
    -- LSP Configuration
    require "sbuercklin/configs/lspconfig",

    -- Treesitter parser
    require "sbuercklin/configs/treesitter",

    -- nvim-cmp engine, snippets, autocomplete sources
    require "sbuercklin/configs/cmp",

    require "sbuercklin/configs/neotest",

     -- Language support, I don't think this needs its own file to configure so it lives here
     {
         'JuliaEditorSupport/julia-vim'
     },

    -----------------------------------------
    -- Visual stuff, like colorschemes
    -----------------------------------------
    require "sbuercklin/configs/visual",

    -----------------------------------------
    -- Local projects and integrations
    -----------------------------------------
    -- Local library of helpful functions
    require "sbuercklin/configs/samlib",

    -- My preferred tmux integration with keybinds and whatnot
    require "sbuercklin/configs/stmux",
   
    -- My language interactions
    require "sbuercklin/configs/sjulia",
    require "sbuercklin/configs/srust",
    
    -- Slime helpers
    require "sbuercklin/configs/sslime",
    
    -- Note integrations
    require "sbuercklin/configs/snotes",
}

require("lazy").setup(plugins, opts)

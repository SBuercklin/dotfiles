require("sbuercklin")
require("sbuercklin.packer")
require("sbuercklin.lib")
require("sbuercklin.julia-repl")
require("sbuercklin.notes")

-- Settings for nvim-tree
if isModuleAvailable('nvim-tree') then
    vim.g.loaded_netrew = 1
    vim.g.loaded_netrwPlugin = 1
end

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true


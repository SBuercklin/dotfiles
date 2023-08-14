local lib = require("sbuercklin.lib")

-- Settings for nvim-tree
if lib.isModuleAvailable('nvim-tree') then
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
end

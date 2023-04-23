require("sbuercklin")
require("sbuercklin.packer")

function isModuleAvailable(name)
  if package.loaded[name] then
    return true
  else
    for _, searcher in ipairs(package.searchers or package.loaders) do
      local loader = searcher(name)
      if type(loader) == 'function' then
        package.preload[name] = loader
        return true
      end
    end
    return false
  end
end

-- Settings for nvim-tree
if isModuleAvailable('nvim-tree') then
    vim.g.loaded_netrew = 1
    vim.g.loaded_netrwPlugin = 1
end

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true


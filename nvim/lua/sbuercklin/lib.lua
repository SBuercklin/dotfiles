local M = {}
-- Ref: https://stackoverflow.com/a/15434737
function M.isModuleAvailable(name)
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

function M.dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. M.dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function M.get_normalized_home()
    local home = os.getenv("HOME")
    if string.sub(home, -1) ~= '/' then
        home = home .. '/'
    end

    return home
end

function M.get_sorted_files(dir, opts)
    local files = vim.fs.dir(dir, opts)
    local i = 1
    local files_table = {}

    for a,_ in files do
        files_table[i] = a
        i = i + 1
    end
    table.sort(files_table)

    return files_table
end

function M.find_in_table(t, val)
    for i,v in ipairs(t) do
        if v == val then
            return i
        end
    end

    return nil
end

return M

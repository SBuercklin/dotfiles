local api = vim.api
local fn = vim.fn

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

function M.split_delimiter(s, delim)
    local retval = {}
    local i = 1
    for l in string.gmatch(s, '([^'..delim..']+)') do
        retval[i] = l
        i = i + 1
    end

    return retval
end

function M.split_lines(s) return M.split_delimiter(s, '\n') end

-- Opens a floating with with some proportion of the current window
function M.open_win(N)
    N = N or 10
    local width = math.floor(fn.winwidth(0) / N)
    local height = math.floor(fn.winheight(0) / N)

    local w = api.nvim_open_win(0, true, {relative='win', row=height, col=width, width=width*(N-2), height=height*(N-2), border="double"})

    vim.wo[w].nu = false
    vim.wo[w].rnu = false
end

-- Ref: https://stackoverflow.com/questions/4990990/check-if-a-file-exists-with-lua
function M.file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function M.backup_mark(name, buf)
    buf = buf or 0
    local mark_data = api.nvim_buf_get_mark(buf, name)

    return { buf, name, mark_data[1], mark_data[2] }
end

function M.restore_mark(args)
    local buffer = args[1]
    local name = args[2]
    local line = args[3]
    local col = args[4]
    return api.nvim_buf_set_mark(buffer, name, line, col)
end

function M.inTableValues(val, tbl)
    for _,v in pairs(tbl) do
        if val == v then
            return true
        end
    end
    return false
end

return M

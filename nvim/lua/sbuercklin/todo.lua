local api = vim.api
local fn = vim.fn
local lib = require("sbuercklin.lib")
local notes = require("sbuercklin.notes")

local M = {}

-- TODO:
-- 1. Parse each header and entries in the todo file and generate a table of those
-- 2. If any of the items are done under each header, mark them as done in the originating files
-- 3. Add ability to manually curate todo lists under headers which aren't files
-- 4. Keymaps to toggle entries in the todo list between done/not done
-- 5. Check local dir for a todo file before we go to the global todo

function M.get_todo_file()
    return lib.get_normalized_home() .. ".sam-todo.md"
end

-- Note that this assumes we have ripgrep (rg) installed, much like we
--     use rg with telescope to grep full directories
function M.grep_notes_dir()
    local cwd = notes.get_note_dir()
    local search = "\"^\\[ \\]\""

    local cmd = "rg --no-heading -n -w " .. search .. " " .. cwd

    return vim.fn.system(cmd)
end

function M.get_todo_objects()
    local note_string = M.grep_notes_dir()

    local lines = lib.split_lines(note_string)

    local t = {}
    for _,l in pairs(lines) do
        local split_segments = lib.split_delimiter(l, ':')
        local fname = split_segments[1]
        local fline = tonumber(split_segments[2])

        local string_contents = ""
        local i = 3
        while i <= #split_segments do
            string_contents = string_contents .. split_segments[i]
            i = i + 1
        end

        table.insert(t, {fname = fname, line_num = fline, line = string_contents})
    end

    return t
end

function M.todos_to_full_notes(todos)
    local todo_lines = {}
    for _,t in pairs(todos) do
        table.insert(todo_lines, M.todo_to_full_note(t))
    end

    return todo_lines
end

function M.todo_to_full_note(todo)
    local fname = todo["fname"]
    local line_num = todo["line_num"]

    local todo_str = todo["line"] .. '\n'

    local done = false
    local i = 1
    for l in io.lines(fname) do
        if (i > line_num) and (not done) then
            done = M.doneline(l)
            if not done then
                todo_str = todo_str..l..'\n'
            end
        end
        if done then
            return { todo_str = todo_str, todo_fname = fname }
        end
        i = i + 1
    end

    return { todo_str = todo_str, todo_fname = fname }
end

function M.doneline(l)
    local new_todo = string.match(l, '^%[ %]')
    local emptyline = string.match(l, '^[ ]*$')
    if new_todo ~= nil or emptyline ~= nil then
        return true
    else
        return false
    end
end

function M.compare_notes_by_fname(a, b)
    return a["todo_fname"] < b["todo_fname"]
end

function M.todos_to_string(todo_strings_with_fname)
    table.sort(todo_strings_with_fname, M.compare_notes_by_fname)

    local current_fname = todo_strings_with_fname[1]["todo_fname"]
    local todostr = '# '..current_fname..'\n '..'\n'
    for _,t in pairs(todo_strings_with_fname) do
        new_fname = t["todo_fname"]
        if new_fname ~= current_fname then
            todostr = todostr..' \n # '..new_fname..'\n \n'
            current_fname = new_fname
        end
        todostr = todostr..t["todo_str"]
    end

    return todostr
end

function M.create_todo_list(todos)
    local todo_strings_with_fname = M.todos_to_full_notes(todos)

    local todo_file_string = M.todos_to_string(todo_strings_with_fname)


    return todo_file_string
end

function M.show_todo_list()
    local todos = M.get_todo_objects()
    local todostr = M.create_todo_list(todos)

    lib.open_win()

    local todo_file = M.get_todo_file()

    vim.cmd('e '..todo_file)
    local b = api.nvim_get_current_buf()

    local oneline = fn.getbufline(b, 1)[1]
    if oneline:len() == 0 then
        for i,l in pairs(lib.split_lines(todostr)) do
            fn.appendbufline(b, i-1, l)
        end
    end
end

vim.keymap.set('n', '<leader>nt', M.show_todo_list)

return M

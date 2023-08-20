-- -- Prints all of the files in the  directory
-- print(vim.fn.getcwd())
-- print(vim.loop.os_homedir())
-- print(vim.fs.dirname(vim.loop.os_homedir()))
-- -- for i in vim.fs.dir(vim.fn.getcwd()) do
-- --     print(i)
-- -- end


-- local test_dirs = vim.fs.find(
--     '.vimrc', 
--     { upward = true, stop = vim.fs.dirname(vim.loop.os_homedir()), path = vim.fn.getcwd() }
--     )

-- for k,v in pairs(test_dirs) do 
--     print(v)
-- end

local tmux = require("sbuercklin.tmux")

local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values

-- our picker function: colors
local colors = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "colors",
    finder = finders.new_table {
      results = { "red", "green", "blue" }
    },
    sorter = conf.generic_sorter(opts),
  }):find()
end

-- to execute the function
-- colors(require("telescope.themes").get_dropdown{})

local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local attachables = function(opts)
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "select pane to attach",
    finder = finders.new_table {
      results = tmux.get_windowlist(),
      -- entry_maker = 
    },
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        tmux.attach_existing_pane(selection[1])
      end)
      return true
    end,
  }):find()
end

-- colors()
-- attachables()
-- attachables(require("telescope.themes").get_dropdown{})

vim.keymap.set('n', '<leader>ja', function()
    attachables(require("telescope.themes").get_dropdown{})
end
)

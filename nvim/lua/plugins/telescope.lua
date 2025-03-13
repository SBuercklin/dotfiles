---Opens a telescope picker to find active stashed/detached telescope panes
---@param opts: table | none
local function reattach_picker(opts)
    local tmux = require("stmux")
    opts = opts or {}
    local wlist = tmux.get_windowlist()
    local previewers = require("telescope.previewers")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local actions = require("telescope.actions")
    local actions_state = require("telescope.actions.state")
    local conf = require('telescope.config').values
    local lib = require("samlib")

    pickers.new(opts, {
        prompt_title = "Select pane to attach to current tab",
        finder = finders.new_table {
            results = wlist,
        },
        sorter = conf.generic_sorter(opts),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(
                function()
                    actions.close(prompt_bufnr)
                    local entry = actions_state.get_selected_entry()
                    tmux.attach_existing_pane(entry[1])
                end
            )
            return true
        end,
        previewer = previewers.new_buffer_previewer({
            title = "Panel Contents",
            define_preview = function(self, entry, status)
                local contents = lib.split_lines(tmux.get_pane_contents(entry[1]))
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, contents)
            end
        }),
    }):find()
end

-- Selects a directory to grep in after starting a live_grep session
-- https://github.com/nvim-telescope/telescope.nvim/issues/2201#issuecomment-1284691502
-- Requires the telescope-file-browser extension
local ts_select_dir_for_grep = function(prompt_bufnr)
  local action_state = require("telescope.actions.state")
  local fb = require("telescope").extensions.file_browser
  local live_grep = require("telescope.builtin").live_grep
  local current_line = action_state.get_current_line()

  fb.file_browser({
    files = false,
    depth = false,
    attach_mappings = function(prompt_bufnr)
      require("telescope.actions").select_default:replace(function()
        local entry_path = action_state.get_selected_entry().Path
        local dir = entry_path:is_dir() and entry_path or entry_path:parent()
        local relative = dir:make_relative(vim.fn.getcwd())
        local absolute = dir:absolute()

        live_grep({
          results_title = relative .. "/",
          cwd = absolute,
          default_text = current_line,
        })
      end)

      return true
    end,
  })
end

local function grep_notes() require("telescope.builtin").live_grep({ cwd = require("snotes").notes.get_note_dir() }) end

return {
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.5',
        dependencies = { { 'nvim-lua/plenary.nvim' }, { "stmux" }, { "snotes" } },
        opts = {
            pickers = {
                buffers = {
                    mappings = {
                        i = {
                            ["<C-d>"] = "delete_buffer",
                        },
                        n = {
                            ["<C-d>"] = "delete_buffer",
                        }
                    }
                },
                live_grep = {
                    mappings = {
                        i = {
                            ["<C-f>"] = ts_select_dir_for_grep,
                        },
                        n = {
                            ["<C-f>"] = ts_select_dir_for_grep,
                        }
                    }
                }
            }
        },
        keys = {
            { "<leader>ff", function () require("telescope.builtin").find_files() end,            desc = "Telescope files in current dir" },
            { "<leader>fg", function () require("telescope.builtin").live_grep() end,             desc = "Telescope ripgrep in current dir" },
            { '<leader>fa', function () require("telescope.builtin").lsp_workspace_symbols() end, desc = "Telescope LSP workspace symbols" },
            { '<leader>fs', function () require("telescope.builtin").lsp_document_symbols() end,  desc = "Telescope LSP document symbols" },
            { '<leader>fb', function () require("telescope.builtin").buffers() end,               desc = "Telescope open buffers" },
            { '<leader>fh', function () require("telescope.builtin").help_tags() end,             desc = "Telescope help tags" },
            { '<leader>fr', function () require("telescope.builtin").lsp_references() end,        desc = "Telescope LSP references",            noremap = true, silent = true },
            { '<leader>fm', function () require("telescope.builtin").marks() end,                 desc = "Telescope current marks",             noremap = true, silent = true },
            { '<leader>fp', function () require("telescope.builtin").builtin() end,               desc = "Telescope builtin telescope pickers", noremap = true, silent = true },
            { '<leader>fn', function () grep_notes() end,                                         desc = "Telescope grep notes dir" },
            { '<leader>ja', function () reattach_picker() end,                                    desc = "Telescope tmux reattach picker" }
        },

    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }
}

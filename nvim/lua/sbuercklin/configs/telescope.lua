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

local function grep_notes() require("telescope.builtin").live_grep({ cwd = require("snotes").notes.get_note_dir() }) end

return {
    'nvim-telescope/telescope.nvim',
    version = '0.1.5',
    dependencies = { { 'nvim-lua/plenary.nvim' }, { "stmux" }, { "samlib" }, { "snotes" } },
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
            }
        }
    },
    keys = {
        { "<leader>ff", require("telescope.builtin").find_files,            desc = "Telescope files in current dir" },
        { "<leader>fg", require("telescope.builtin").live_grep,             desc = "Telescope ripgrep in current dir" },
        { '<leader>fa', require("telescope.builtin").lsp_workspace_symbols, desc = "Telescope LSP workspace symbols" },
        { '<leader>fs', require("telescope.builtin").lsp_document_symbols,  desc = "Telescope LSP document symbols" },
        { '<leader>fb', require("telescope.builtin").buffers,               desc = "Telescope open buffers" },
        { '<leader>fh', require("telescope.builtin").help_tags,             desc = "Telescope help tags" },
        { '<leader>fr', require("telescope.builtin").lsp_references,        desc = "Telescope LSP references",            noremap = true, silent = true },
        { '<leader>fm', require("telescope.builtin").marks,                 desc = "Telescope current marks",             noremap = true, silent = true },
        { '<leader>fp', require("telescope.builtin").builtin,               desc = "Telescope builtin telescope pickers", noremap = true, silent = true },
        { '<leader>fn', grep_notes,                                         desc = "Telescope grep notes dir" },
        { '<leader>ja', reattach_picker,                                    desc = "Telescope tmux reattach picker" }
    }
}

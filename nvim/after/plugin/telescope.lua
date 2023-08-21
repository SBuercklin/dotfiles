local telescope = require('telescope')
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values

local tmux = require('sbuercklin.tmux')
local lib = require('sbuercklin.lib')

if telescope then
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

    -- Requires you ripgrep to be installed
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

    vim.keymap.set('n', '<leader>fa', builtin.lsp_workspace_symbols, {})
    vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

    vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { noremap = true, silent = true })

    require("telescope").setup {
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
    }

    local notes = require("sbuercklin.notes")

    -- This picker lists all of the detached panels in tstash and previews the contents of the
    --  panel so you can pick the correct one
    function reattach_picker(opts)
      opts = opts or {}
      local wlist = tmux.get_windowlist()
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
              local entry = action_state.get_selected_entry()
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
    
    vim.keymap.set('n', '<leader>fn', function()
        local dir = notes.get_note_dir()
        builtin.live_grep({cwd = dir})
    end)
    vim.keymap.set('n', '<leader>ja', reattach_picker)
end


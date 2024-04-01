function reattach_picker(opts)
      local tmux = require("stmux")
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

return {
       'nvim-telescope/telescope.nvim',
       version = '0.1.5',
       dependencies = {{'nvim-lua/plenary.nvim'}, {"stmux"}, {"samlib"}, {"snotes"}},
       keys = {
           { "<leader>ff", require("telescope.builtin").find_files },
           { "<leader>fg", require("telescope.builtin").live_grep },
           { '<leader>fa', require("telescope.builtin").lsp_workspace_symbols },
           { '<leader>fs', require("telescope.builtin").lsp_document_symbols},
           { '<leader>fb', require("telescope.builtin").buffers },
           { '<leader>fh', require("telescope.builtin").help_tags },
           { '<leader>fr', require("telescope.builtin").lsp_references, noremap = true, silent = true },
           { '<leader>fn', function() 
               require("telescope.builtin").live_grep({cwd = require("snotes").notes.get_note_dir()})
           end
           },
           { '<leader>ja', reattach_picker }
       },
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
       }
    }

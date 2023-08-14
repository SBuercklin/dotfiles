local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

-- Requires you ripgrep to be installed
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})

vim.keymap.set('n', '<leader>fa', builtin.lsp_workspace_symbols, {})
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', '<leader>fr', builtin.lsp_references, { noremap = true, silent = true })

-- require("telescope").setup {
--   pickers = {
--     buffers = {
--       mappings = {
--         i = {
--           ["<C-d>"] = "delete_buffer",
--         },
--         n = {
--           ["<C-d>"] = "delete_buffer",
--         }
--       }
--     }
--   }
-- }

local notes = require("sbuercklin.notes")

vim.keymap.set('n', '<leader>fn', function()
    local dir = notes.get_note_dir()
    builtin.live_grep({cwd = dir})
end)

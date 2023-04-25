local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

-- Requires you ripgrep to be installed
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', '<C-p>', builtin.git_files, {})

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

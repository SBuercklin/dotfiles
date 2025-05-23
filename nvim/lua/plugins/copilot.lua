local toggle_copilot = function()
    if vim.b.copilot_enabled then
        vim.b.copilot_enabled = false
        print("Copilot disabled")
    else
        vim.b.copilot_enabled = true
        print("Copilot enabled")
    end
    local pos = vim.api.nvim_win_get_cursor(0)
    local r, c = pos[1], pos[2]
    local k = vim.api.nvim_replace_termcodes("<Esc>a", true, true, true)
    vim.api.nvim_feedkeys(k, "i", false)
    vim.api.nvim_win_set_cursor(0, { r, c + 1 })
end

return {
    'github/copilot.vim',
    cmd = { 'Copilot' },
    config = function()
        vim.g.copilot_no_maps = true
        vim.cmd('Copilot')
        print("Copilot loaded")

        vim.api.nvim_set_keymap("i", "<A-n>", "<Plug>(copilot-next)",
            { noremap = false, silent = true, desc = "Cycle to next copilot suggestion" })
        vim.api.nvim_set_keymap("i", "<A-p>", "<Plug>(copilot-previous)",
            { noremap = false, silent = true, desc = "Cycle to previous copilot suggestion" })
        vim.api.nvim_set_keymap("i", "<A-Right>", "<Plug>(copilot-accept-word)",
            { noremap = false, silent = true, desc = "Accept copilot word" })
        vim.api.nvim_set_keymap("i", "<A-y>", "<Plug>(copilot-accept-line)",
            { noremap = false, silent = true, desc = "Accept copilot line" })
        vim.api.nvim_set_keymap("i", "<A-x>", "<Plug>(copilot-dismiss)",
            { noremap = false, silent = true, desc = "Dismiss copilot suggestion" })
        vim.keymap.set('i', '<A-Y>', 'copilot#Accept("\\<CR>")', {
          expr = true,
          replace_keycodes = false,
          desc = 'Accept Copilot suggestion',
        })
    end,
    keys = {
        { "<A-,>", toggle_copilot, mode = "i", desc = "Toggle Copilot" },
    }

}

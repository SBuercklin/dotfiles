local slime = require("sslime")


vim.api.nvim_create_augroup("SamRust", { clear = true })
vim.api.nvim_create_autocmd(
    "BufEnter",
    {
        pattern = { "*.rs" },
        callback = function(ev)
            if slime.slime_active() then
                vim.keymap.set(
                    'n', '<leader>jt', function() slime.send_to_terminal('cargo test') end, { buffer = ev['buf'] }
                )
                vim.keymap.set(
                    'n', '<leader>jc', function() slime.send_to_terminal('cargo check') end, { buffer = ev['buf'] }
                )
                vim.keymap.set(
                    'n', '<leader>jm', function() slime.send_to_terminal('cargo run') end, { buffer = ev['buf'] }
                )
            end
        end,
        group = "SamRust"
    }
)

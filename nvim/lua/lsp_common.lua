local M = {}

local goto_prev_diag = function() vim.diagnostic.jump({ count = -1, float = true }) end
local goto_next_diag = function() vim.diagnostic.jump({ count = 1, float = true }) end

local build_keymap = function(cfg)
    vim.keymap.set(
        cfg.mode,
        cfg.keys,
        cfg.cmd,
        cfg.opts
    )
end

M.toggle_inlay_hints = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end

local dflt_opts = { noremap = true, silent = true }

local keymaps = function(bufnr, new_opts)
    local opts = vim.tbl_deep_extend('force', dflt_opts, new_opts)
    local maps = {
        { mode = 'n', keys = 'gD',         cmd = vim.lsp.buf.declaration,    opts = opts },
        { mode = 'n', keys = 'gd',         cmd = vim.lsp.buf.definition,     opts = opts },
        { mode = 'n', keys = 'gi',         cmd = vim.lsp.buf.implementation, opts = opts },

        { mode = 'n', keys = '<C-k>',      cmd = vim.lsp.buf.signature_help, opts = opts },
        { mode = 'i', keys = '<C-k>',      cmd = vim.lsp.buf.signature_help, opts = opts },

        { mode = 'n', keys = 'K',          cmd = vim.lsp.buf.hover,          opts = opts },
        { mode = 'n', keys = '<leader>rn', cmd = vim.lsp.buf.rename,         opts = opts },
        { mode = 'n', keys = 'gr',         cmd = vim.lsp.buf.references,     opts = opts },
        { mode = 'n', keys = '<leader>jf', cmd = vim.lsp.buf.format,         opts = opts },
        { mode = "n", keys = "<leader>a",  cmd = vim.lsp.buf.code_action,    opts = opts },
        { mode = "v", keys = "<leader>a",  cmd = vim.lsp.buf.code_action,    opts = opts },
        { mode = "n", keys = "<leader>jh", cmd = M.toggle_inlay_hints,       opts = opts },

        { mode = 'n', keys = '[d',         cmd = goto_prev_diag,             opts = opts },
        { mode = 'n', keys = ']d',         cmd = goto_next_diag,             opts = opts },
        { mode = 'n', keys = '<leader>q',  cmd = vim.diagnostic.setloclist,  opts = opts },
        { mode = 'n', keys = '<leader>jw', cmd = vim.diagnostic.open_float,  opts = opts },
    }

    return maps
end

local attach_fn = function(bufnr, extras)
    extras = extras or {}
    vim.tbl_deep_extend('force', { buffer = bufnr }, extras)

    local new_keymaps = keymaps(bufnr, extras)
    for _, mapping in pairs(new_keymaps) do
        build_keymap(mapping)
    end
end

local sam_lsp_augrp = "SamLspAttach"
vim.api.nvim_create_augroup(sam_lsp_augrp, { clear = true })

vim.api.nvim_create_autocmd(
    'LspAttach',
    {
        callback = function(ev)
            attach_fn(ev.buf)
        end,
        group = sam_lsp_augrp
    }
)

--[[
-------------------------
    Formatting logic
-------------------------
]]

local format_augrp = "SamLspFormatting"
vim.api.nvim_create_augroup(format_augrp, { clear = true })

M.format_autocmd = function(bufnr)
    -- Only want one formatter per buffer
    vim.api.nvim_clear_autocmds({
        buffer = bufnr,
        group = format_augrp
    })
    vim.api.nvim_create_autocmd(
        'BufWritePre', {
            callback = function(ev)
                print("Formatting")
                vim.lsp.buf.format({ async = false })
            end,
            buffer = bufnr,
            group = format_augrp
        }
    )
    -- Sometimes the Julia server detaches and it causes problems
    vim.api.nvim_create_autocmd(
        'LspDetach', {
            callback = function(ev)
                vim.api.nvim_clear_autocmds({
                    buffer = bufnr,
                    group = format_augrp
                })
            end
        }
    )
end

return M

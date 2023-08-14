local lsp = require('lspconfig')
local lib = require('sbuercklin.lib')

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Enable LSP logging
-- vim.lsp.set_log_level("debug")

-- Diagnostic shortcuts, pulled from lspconfig docs
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

local attach_fn = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'F2', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
end

local format_autocmd = function(bufnr)
    vim.api.nvim_create_autocmd(
        'BufWritePre', {
            callback = function(ev)
                vim.lsp.buf.format()
            end,
            buffer = bufnr
        }
    )
end

--------------------------------------------
-- Language specific configurations
--------------------------------------------

lsp.julials.setup(
    {
        on_attach = function(client, bufnr)
            attach_fn(client, bufnr)

            -- This is used to determine if we want to autoformat
            --  kinda hacky but it works
            local fname = vim.api.nvim_buf_get_name(0)
            local dname = vim.fs.dirname(fname)
            local dirs = vim.fs.find('.JuliaFormatter.toml',  { upward = true, path = dname })
            if not(next(dirs) == nil) then
                format_autocmd(bufnr)
            end
        end,
        capabilities = capabilities
    }
)

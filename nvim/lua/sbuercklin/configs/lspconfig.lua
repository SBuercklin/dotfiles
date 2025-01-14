--[[
-------------------------
    LSP Keymaps
-------------------------
]]
local build_keymap = function(cfg)
    vim.keymap.set(
        cfg.mode,
        cfg.keys,
        cfg.cmd,
        cfg.opts
    )
end

local toggle_inlay_hints = function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({})) end

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
        { mode = "n", keys = "<leader>jh", cmd = toggle_inlay_hints,         opts = opts },

        -- Diagnostic shortcuts, pulled from lspconfig docs
        { mode = 'n', keys = '[d',         cmd = vim.diagnostic.goto_prev,   opts = opts },
        { mode = 'n', keys = ']d',         cmd = vim.diagnostic.goto_next,   opts = opts },
        { mode = 'n', keys = '<leader>q',  cmd = vim.diagnostic.setloclist,  opts = opts },
        { mode = 'n', keys = '<leader>jw', cmd = vim.diagnostic.open_float,  opts = opts },
    }

    return maps
end

local attach_fn = function(bufnr)
    local new_keymaps = keymaps(bufnr, {})
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

local format_autocmd = function(bufnr)
    -- Only want one formatter per buffer
    vim.api.nvim_clear_autocmds({
        buffer = bufnr,
        group = format_augrp
    })
    vim.api.nvim_create_autocmd(
        'BufWritePre', {
            callback = function(ev)
                print("Formatting")
                vim.lsp.buf.format()
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

--[[
-------------------------
    LSP Configurations
-------------------------
]]

local lsp_configs = {}

local julials_config = {
    on_attach =
        function(client, bufnr)
            -- This is used to determine if we want to autoformat
            --  kinda hacky but it works
            local fname = vim.api.nvim_buf_get_name(0)
            local dname = vim.fs.dirname(fname)
            local dirs = vim.fs.find('.JuliaFormatter.toml', { upward = true, path = dname })
            if not (next(dirs) == nil) then
                format_autocmd(bufnr)
            end
        end,
    init_options = { julialangTestItemIdentification = true },
}

-- Requires latexindent and latexmk for formatting and building respectively
local texlab_config = {
    on_attach = function(_, bufnr)
        format_autocmd(bufnr)
        vim.keymap.set("n", "<Leader>jm", vim.cmd["TexlabBuild"])
    end,
    settings = {
        texlab = {
            build = {
                executable = 'latexmk',
                args = { '-shell-escape', '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
            }
        }
    }
}

local rust_analyzer_config = {
    on_attach = function(client, bufnr) format_autocmd(bufnr) end
}

local lua_ls_config = {
    on_attach = function(client, bufnr) format_autocmd(bufnr) end
}

-- Use pyenv to install proper pythong versions
-- Construct your virtualenv in whatever project you want
-- Add python-lsp-server as a dev dependency and run with that virtualenv active to have pylsp cmd available
-- e.g. `poetry run nvim` to run with the current project loaded so you get the proper autocomplete
local pylsp_config = {
    -- on_attach = function(client, bufnr) format_autocmd(bufnr) end,
    settings = {
        pylsp = {
            configurationSources = { 'flake8' },
            plugins = {
                flake8 = {
                    enabled = false,
                    ignore = { 'E501', 'E231' },
                    maxLineLength = 88,
                },
                black = { enabled = true },
                -- autopep8 = { enabled = false },
                -- mccabe = {enabled = false},
                pycodestyle = {
                    enabled = true,
                    ignore = { 'E501', 'E231' },
                    maxLineLength = 88,
                },
                -- pyflakes = {enabled = false},
            },
        },
    },
}

lsp_configs.julials = julials_config
lsp_configs.rust_analyzer = rust_analyzer_config
lsp_configs.texlab = texlab_config
lsp_configs.lua_ls = lua_ls_config
lsp_configs.pylsp = pylsp_config

--[[
-------------------------
    LSP Setup
-------------------------
]]

local setup_lsp = function()
    local lsp = require('lspconfig')

    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    local dflt_lsp_cfg = { capabilities = capabilities }

    -- Iterate over the servers and configure them
    for server, server_cfg in pairs(lsp_configs) do
        local local_cfg = vim.tbl_deep_extend('force', dflt_lsp_cfg, server_cfg)

        lsp[server].setup(local_cfg)
    end

    -- Enable LSP logging
    -- vim.lsp.set_log_level("debug")
end

--[[
-------------------------
    The actual lazy config
-------------------------
]]

return {
    {
        'williamboman/mason.nvim',
        config = true,
        lazy = true
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'hrsh7th/cmp-nvim-lsp' },
        },
        config = setup_lsp,
        ft = { "julia", "rust", "python", "latex", "lua" }
    },
}

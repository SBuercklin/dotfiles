local attach_fn = function(client, bufnr)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, keymap_opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, keymap_opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, keymap_opts)

    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, keymap_opts)
    vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, keymap_opts)

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, keymap_opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, keymap_opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, keymap_opts)
    vim.keymap.set('n', '<leader>jf', vim.lsp.buf.format, keymap_opts)
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)
    vim.keymap.set("n", "<leader>jh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)
            
    -- Diagnostic shortcuts, pulled from lspconfig docs
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)
    vim.keymap.set('n', '<leader>jw', vim.diagnostic.open_float)
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


return {
     {
         'williamboman/mason.nvim',
         config = function (_)
            require("mason").setup()
         end
     },
     {
         'neovim/nvim-lspconfig',
         dependencies = {
             {'williamboman/mason.nvim'},
             {'williamboman/mason-lspconfig.nvim'},
             {'hrsh7th/cmp-nvim-lsp'},
         },
         config = function (_, opts)
            local lsp = require('lspconfig')

            -- require('mason').setup()

            local capabilities = require('cmp_nvim_lsp').default_capabilities
            local keymap_opts = { noremap = true, silent = true, buffer = bufnr }

            -- Enable LSP logging
            -- vim.lsp.set_log_level("debug")

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
                    capabilities = capabilities()
                }
            )

            -- Requires latexindent and latexmk for formatting and building respectively
            lsp.texlab.setup(
                {
                    on_attach = function(client, bufnr)
                        attach_fn(client, bufnr)
                        format_autocmd(bufnr)
                        vim.keymap.set("n", "<Leader>jm", vim.cmd["TexlabBuild"])
                    end,
                    capabilities = capabilities(),
                    settings = {
                        texlab = {
                            build = {
                              executable = 'latexmk',
                              args = { '-shell-escape', '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
                            }
                        }
                    }
                }
            )

            lsp.rust_analyzer.setup(
                {
                    on_attach = function(client, bufnr)
                        attach_fn(client, bufnr)

                        format_autocmd(bufnr)
                    end,
                    capabilities = capabilities()
                }
            )
            

            -- Use pyenv to install proper pythong versions
            -- Construct your virtualenv in whatever project you want
            -- Add python-lsp-server as a dev dependency and run with that virtualenv active to have pylsp cmd available
            -- e.g. `poetry run nvim` to run with the current project loaded so you get the proper autocomplete
            lsp.pylsp.setup(
                {
                    on_attach = function(client, bufnr)
                        attach_fn(client, bufnr)

                        -- format_autocmd(bufnr)
                    end,
                    capabilities = capabilities(),
                }
            )
         end
     },
 }

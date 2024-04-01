return {
         'neovim/nvim-lspconfig',
         dependencies = {
             {'williamboman/mason.nvim'},
             {'williamboman/mason-lspconfig.nvim'},
             {'hrsh7th/cmp-nvim-lsp'},
             {'simrat39/rust-tools.nvim'},
         },
         config = function (_, opts)
            local lsp = require('lspconfig')

            -- require('mason').setup()

            local capabilities = require('cmp_nvim_lsp').default_capabilities
            local keymap_opts = { noremap = true, silent = true, buffer = bufnr }

            -- Enable LSP logging
            -- vim.lsp.set_log_level("debug")

            -- Diagnostic shortcuts, pulled from lspconfig docs
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

            local attach_fn = function(client, bufnr)
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, keymap_opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, keymap_opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, keymap_opts)
                vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, keymap_opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, keymap_opts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, keymap_opts)
                vim.keymap.set('n', 'F2', vim.lsp.buf.rename, keymap_opts)
                vim.keymap.set('n', 'gr', vim.lsp.buf.references, keymap_opts)
                vim.keymap.set('n', '<leader>jf', vim.lsp.buf.format, keymap_opts)
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

                        vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action)

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

            -- Note that to configure the pyright env, use the venv and venvPath entries in the project config:
            --    https://github.com/microsoft/pyright/blob/main/docs/configuration.md
            lsp.pyright.setup(
                {
                    on_attach = function(client, bufnr)
                        attach_fn(client, bufnr)
                    end,
                    capabilities = capabilities()
                }
            )

            -- TODO: Move away from rust-tools (or rustaceanvim) and just use the LSP directly
            local rt = require("rust-tools")
            rt.setup(
                {
                    server = {
                        on_attach = function(client, bufnr)
                            attach_fn(client, bufnr)
                            
                            format_autocmd(bufnr)
                            vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, keymap_opts)
                            vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, keymap_opts)
                        end
                    }
                }
            )
         end
     }

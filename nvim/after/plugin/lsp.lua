local lsp = require('lsp-zero')
lsp.preset('recommended')


-- Installed the julials using Mason
-- Installed the proper environment following this post: 
--      https://discourse.julialang.org/t/neovim-languageserver-jl/37286/83
--      julia --project=~/.julia/environments/nvim-lspconfig -e 'using Pkg; Pkg.add("LanguageServer")'
lsp.ensure_installed({
    'julials',
})

lsp.setup()

local cmp = require('cmp')

cmp.setup({
    mapping = {
        ['<Tab>'] = cmp.mapping.confirm({select = false}),
        ['<Tab>'] = cmp.mapping.confirm({select = true})
    }
})

-- Determine if we have a .JuliaFormatter.toml and set a variable to indicate this is true
vim.api.nvim_create_autocmd(
    'BufEnter', { 
        pattern = {"*.jl"},
        callback = function(ev) 
            local fname = vim.api.nvim_buf_get_name(0)
            local dname = vim.fs.dirname(fname)
            local dirs = vim.fs.find('.JuliaFormatter.toml',  { upward = true, path = dname })
            if next(dirs) == nil then
                vim.api.nvim_buf_set_var(0, 'JLFORMAT', false)
            else
                vim.api.nvim_buf_set_var(0, 'JLFORMAT', true)
            end
        end
    }
)

vim.api.nvim_create_autocmd(
    'BufWritePre', {
        pattern = {"*.jl"},
        callback = function(ev)
            if vim.api.nvim_buf_get_var(0, 'JLFORMAT') then
                vim.lsp.buf.format()
            end
        end
    }
)
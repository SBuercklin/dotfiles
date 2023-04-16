local lsp = require('lsp-zero')
lsp.preset('recommended')


-- Installed the julials using Mason
-- Installed the proper environment following this post: 
--      https://discourse.julialang.org/t/neovim-languageserver-jl/37286/83
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

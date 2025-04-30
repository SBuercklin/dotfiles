return {
    'hrsh7th/nvim-cmp',
    enabled = false,
    dependencies = {
        { 'hrsh7th/cmp-cmdline' },
        { 'hrsh7th/cmp-buffer' },
        { 'hrsh7th/cmp-nvim-lua' },
        { 'hrsh7th/cmp-nvim-lsp' },
        { 'kdheepak/cmp-latex-symbols' }, -- needed for Julia autocomplete of symbol

        { 'rafamadriz/friendly-snippets' },
        { 'L3MON4D3/LuaSnip',            opts = { region_check_events = { 'InsertEnter' } } },
        { 'saadparwaiz1/cmp_luasnip' },
    },
    config = function(_, _)
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        -- Loads local snippets
        require("luasnip.loaders.from_snipmate").load({ paths = { "~/.config/nvim/snippets/snipmate/" } })

        local has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        cmp.setup({
            snippet = {
                expand = function(args)
                    -- Pull snippets from luasnip
                    luasnip.lsp_expand(args.body) -- Use this to get snippets from the LSP
                    -- luasnip.expand(args.body) -- Use this to just use local snippets
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'nvim_lua' },
                { name = 'latex_symbols', option = { strategy = 1 } }, -- Julia autocomplete of symbols
            }, {
                { name = 'buffer' },
            }),
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        -- cmp.setup.cmdline(':', {
        --     mapping = cmp.mapping.preset.cmdline(),
        --     sources = cmp.config.sources({
        --         -- { name = 'path' }
        --     }, {
        --         { name = 'cmdline' }
        --     })
        -- })
    end,
    event = "InsertEnter"
}

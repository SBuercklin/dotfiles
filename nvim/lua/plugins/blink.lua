return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    -- use a release tag to download pre-built binaries
    version = '1.*',

    opts = {
        keymap = {
            preset = 'default',
            ['<C-p>'] = { 'show', 'select_prev', 'fallback_to_mappings' },
            ['<C-n>'] = { 'show', 'select_next', 'fallback_to_mappings' },
        },

        completion = {
            documentation = { auto_show = false }, -- C-space will show docs
            menu = {
                auto_show = false,
                draw = {
                    columns = { { 'kind' }, { 'label', 'label_description', gap = 1 } }
                }
            },
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
    },
    opts_extend = { "sources.default" }
}

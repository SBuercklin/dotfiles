return {
    -- Surround motions, e.g. cs"} to change surrounding " to matched }
    {
        "kylechui/nvim-surround",
        opts = {}
    },

    -- gS to split/combine contents across multiple lines
    {
        'echasnovski/mini.splitjoin',
        opts = {}
    },

    -- Comments. gbc for block comments, gcc for regular comments, g{b,c}<movement> also works
    {
        'numToStr/Comment.nvim',
        opts = {},
    },

    -- Autopairs
    {
        'windwp/nvim-autopairs',
        opts = {
            enable_check_bracket_line = false,
            ignored_next_char = "[%w%.]"
        }
    },

    -- Reorders arguments to functions
    {
        'machakann/vim-swap',
        keys = {
            { "g>", },
            { "g<", },
            { "gs", },
        },
    }
}

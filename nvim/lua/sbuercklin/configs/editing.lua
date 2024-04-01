return {
    -- Surround motions, e.g. cs"} to change surrounding " to matched }
    {
       "kylechui/nvim-surround",
       version = "*", 
       config = function() require("nvim-surround").setup({}) end
    },

    -- gS to split/combine contents across multiple lines
    {
        'echasnovski/mini.splitjoin', 
        version = '*',
        config = true,
    },

    -- Comments. gbc for block comments, gcc for regular comments, g{b,c}<movement> also works
    {
        'numToStr/Comment.nvim',
        opts = {},
    },

    -- Autopairs
    {
        'windwp/nvim-autopairs',
        config = function () 
            require('nvim-autopairs').setup( 
            {
                enable_check_bracket_line = false,
                ignored_next_char = "[%w%.]"
            } 
            )
        end
    },
}

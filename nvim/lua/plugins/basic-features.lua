-- Commentary with block and line comments
-- Configurable autopairs

return {
    {
        'numToStr/Comment.nvim', -- Comments. gbc for block comments, gcc for regular comments, g{b,c}<movement> also works
        opts = {},
    },
    {
        'windwp/nvim-autopairs', -- Autopairs
        opts = {
            enable_check_bracket_line = false,
            ignored_next_char = "[%w%.]"
        }
    }
}

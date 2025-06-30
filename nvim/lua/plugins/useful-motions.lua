-- surround is an extremely useful vim motion
-- splitjoin is useful for splitting/combining comma-delimited lists inside of some sort of brackets

return {
    {
        "kylechui/nvim-surround",     -- Surround motions, e.g. cs"} to change surrounding " to matched }
        opts = {}
    },
    {
        'echasnovski/mini.splitjoin',     -- gS to split/combine inside brackets
        opts = {},
        keys = { "gS", }
    }
}

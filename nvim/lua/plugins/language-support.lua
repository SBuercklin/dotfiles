-- julia integration
-- lazydev and luvit-meta for local lua/nvim stuff

return {
    {
        'JuliaEditorSupport/julia-vim',
        filetype = "julia"
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
}

-- NOTE: You might need to delete/remove/etc the local installation of parsers for
-- languages, and if you're coming from packer then it can also cause parser issues
return {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")
        configs.setup(
            {
                -- parser_install_dir = "~/.local/share/nvim/site/parsers",
                ignore_install = {},
                sync_install = true,
                auto_install = true,
                modules = {},
                ensure_installed = { "lua", "vim", "vimdoc", "query", "julia", "python", "rust", },

                -- If you need to change the installation directory of the parsers (see -> Advanced Setup)
                -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

                highlight = {
                    enable = true,
                    disable = function(lang, buf)
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            return true
                        end
                        if lang == "lua" then
                            return true
                        end
                    end,
                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "cn", -- set to `false` to disable one of the mappings
                        node_incremental = "ck",
                        scope_incremental = false,
                        node_decremental = "cj",
                    },
                }
            }
        )
    end
}

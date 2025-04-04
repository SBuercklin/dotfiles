return {
    {
        "nvim-neotest/neotest",
        enabled = false,
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
            "sbuercklin/neotest-julials"
        },
        opts = function(_opts)
            local my_opts = {
                adapters = {
                    require("neotest-julials"),
                    require("neotest-python")({ dap = { justMyCode = false } })
                },
                icons = {
                    failed = "F",
                    notify = "!",
                    passed = "✓",
                    running = "R",
                    skipped = "S",
                    unknown = "?",
                    watching = "W"
                }
            }
            opts = vim.tbl_deep_extend('force', _opts, my_opts)

            return opts
        end,
        init = function()
            local nt = require("neotest")
            vim.api.nvim_create_user_command("NeotestToggle", nt.summary.toggle, {})
            vim.api.nvim_create_user_command("NeotestRun", nt.run.run, {})
            vim.api.nvim_create_user_command(
                "NeotestRunFile",
                function() nt.run.run(vim.fn.expand("&")) end,
                {}
            )
            vim.api.nvim_create_user_command(
                "NeotestToggleOutput",
                nt.output_panel.toggle,
                {}
            )
        end,
        cmd = { "Neotest", "NeotestToggle", "NeotestRun", "NeotestRunFile", "NeotestToggleOutput" }
    },
}

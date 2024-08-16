return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "sbuercklin/neotest-julials",
        "nvim-neotest/neotest-python"
    },
    config = function ()
        local nt = require("neotest")
        nt.setup({
          adapters = {
            require("neotest-julials"),
            require("neotest-python")({dap = { justMyCode = false }})
          },
          icons = {
            failed = "F",
            notify = "!",
            passed = "✓",
            running = "R",
            skipped = "S",
            unknown = "?",
            watching = "W"
          },
        })
        vim.api.nvim_create_user_command("NeotestToggle", nt.summary.toggle, {})
        vim.api.nvim_create_user_command("NeotestRun", nt.run.run, {})
        vim.api.nvim_create_user_command(
            "NeotestRunFile",
            function () nt.run.run(vim.fn.expand("&")) end,
            {}
        )
        vim.api.nvim_create_user_command(
            "NeotestToggleOutput",
            nt.output_panel.toggle,
            {}
        )
    end
}

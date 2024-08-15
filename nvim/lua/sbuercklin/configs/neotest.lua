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
        require("neotest").setup({
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
    end
}

local ui_config = {
    icons = { expanded = "🞃", collapsed = "🞂", current_frame = "→" },
    controls = {
        icons = {
            pause = "⏸",
            play = "⯈",
            step_into = "↴",
            step_over = "↷",
            step_out = "↑",
            step_back = "↶",
            run_last = "🗘",
            terminate = "🕱",
            disconnect = "⏻"
        }
    }
}
return {
    {
        "mfussenegger/nvim-dap",
        keys = { "<leader>b", "<leader>B", "<F1>", "<F2>", "<F3>", "<F4>", "<F5>", "<F12>", }
    },
    {
        "mfussenegger/nvim-dap-python",
        config = function()
            require("dap-python").setup("python")
        end,
        ft = "python"
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
            "kdheepak/nvim-dap-julia"
        },
        config = function()
            local dap = require("dap")
            require("dapui").setup(ui_config)
            require("nvim-dap-julia").setup()


            vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
            vim.keymap.set("n", "<leader>B", dap.run_to_cursor)
            vim.keymap.set("n", "<leader>o", require("dapui").toggle)

            vim.keymap.set("n", "<F1>", dap.continue)
            vim.keymap.set("n", "<F2>", dap.step_into)
            vim.keymap.set("n", "<F3>", dap.step_over)
            vim.keymap.set("n", "<F4>", dap.step_out)
            vim.keymap.set("n", "<F5>", dap.step_back)
            vim.keymap.set("n", "<F12>", dap.restart)
        end,
        keys = { "<leader>o" }
    }
}

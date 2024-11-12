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
            "nvim-neotest/nvim-nio"
        },
        config = function()
            require("dapui").setup(ui_config)
        end
    }
}

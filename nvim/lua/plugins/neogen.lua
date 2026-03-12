return {
    "danymat/neogen",
    version = "*",
    opts = {
        input_after_comment = false,
        languages = {
            python = {
                template = {
                    annotation_convention = "reST",
                },
            },
        },
    },
    keys = {
        { "<leader>nf", function() require("neogen").generate() end, mode = "n", "Neogen Generate Docstring" }
    }

}

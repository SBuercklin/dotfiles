return {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    event = {
        -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        -- refer to `:h file-pattern` for more examples
        "BufReadPre " .. vim.fn.expand "~" .. "/Documents/SBuercklin Vault/*.md",
        "BufNewFile " .. vim.fn.expand "~" .. "/Documents/SBuercklin Vault/*.md",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "sbuercklin",
                path = vim.fn.expand "~" .. "/Documents/SBuercklin Vault/",
            },
        },
        completion = {
            nvim_cmp = false,
            blink = true
        },
        daily_notes = {
            folder = "daily",
            workdays_only = false
        },
        note_id_func = function(title)
            -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
            -- In this case a note with the title 'My new note' will be given an ID that looks
            -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'.
            -- You may have as many periods in the note ID as you'd like—the ".md" will be added automatically
            local suffix = ""
            if title ~= nil then
                -- If title is given, transform it into valid file name.
                return title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
                -- If title is nil, just add 4 random uppercase letters to the suffix.
                for _ = 1, 4 do
                    suffix = suffix .. string.char(math.random(65, 90))
                end
                return tostring(os.time()) .. "-" .. suffix
            end
        end,
    },
}

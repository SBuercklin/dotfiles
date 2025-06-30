local lsp_helper = require("lsp_common")

--[[
-------------------------
    LSP Configurations
-------------------------
]]

vim.lsp.config('*', {
    root_markers = { '.git' },
})


local jl_cmd = {
    'julia',
    '--startup-file=no',
    '--history-file=no',
    '-e',
    [[
    # Load LanguageServer.jl: attempt to load from ~/.julia/environments/nvim-lspconfig
    # with the regular load path as a fallback
    ls_install_path = joinpath(
        get(DEPOT_PATH, 1, joinpath(homedir(), ".julia")),
        "environments", "nvim-lspconfig"
    )
    pushfirst!(LOAD_PATH, ls_install_path)
    using LanguageServer
    popfirst!(LOAD_PATH)
    depot_path = get(ENV, "JULIA_DEPOT_PATH", "")
    project_path = let
        dirname(something(
            ## 1. Finds an explicitly set project (JULIA_PROJECT)
            Base.load_path_expand((
                p = get(ENV, "JULIA_PROJECT", nothing);
                p === nothing ? nothing : isempty(p) ? nothing : p
            )),
            ## 2. Look for a Project.toml file in the current working directory,
            ##    or parent directories, with $HOME as an upper boundary
            Base.current_project(),
            ## 3. First entry in the load path
            get(Base.load_path(), 1, nothing),
            ## 4. Fallback to default global environment,
            ##    this is more or less unreachable
            Base.load_path_expand("@v#.#"),
        ))
    end
    @info "Running language server" VERSION pwd() project_path depot_path
    server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path)
    server.runlinter = true
    run(server)
  ]],
}

vim.lsp.config('julials',
    {
        on_attach = function(client, bufnr)
            -- This is used to determine if we want to autoformat
            --  kinda hacky but it works
            local fname = vim.api.nvim_buf_get_name(0)
            local dname = vim.fs.dirname(fname)
            local dirs = vim.fs.find('.JuliaFormatter.toml', { upward = true, path = dname })
            if not (next(dirs) == nil) then
                lsp_helper.format_autocmd(bufnr)
            end
        end,
        cmd = jl_cmd,
        init_options = { julialangTestItemIdentification = true },
        filetype = { 'julia' },
        root_markers = { 'Project.toml', '.git' }
    })

vim.lsp.config('texlab', {
    settings = {
        texlab = {
            build = {
                executable = 'latexmk',
                args = { '-shell-escape', '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
            }
        }
    }
})

vim.lsp.config('rust_analyzer', {
    on_attach = function(client, bufnr)
        lsp_helper.format_autocmd(bufnr)
    end
})

vim.lsp.config('lua_ls', {
    on_attach = function(client, bufnr)
        lsp_helper.format_autocmd(bufnr)
    end,
    filetype = { 'lua' }
})

vim.lsp.config('ts_ls', {
    filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
})


-- LSP Enabling
local try_enable = function(executable_name, lsp_name)
    -- print(executable_name)
    -- print(vim.fn.executable(executable_name))
    if vim.fn.executable(executable_name) ~= 0 then
        -- print("Enabling ", lsp_name)
        vim.lsp.enable(lsp_name)
    end
end

--[[
-------------------------
    Default configurations using nvim-lspconfig
-------------------------
]]

return {
    {
        'williamboman/mason.nvim',
        config = true,
        lazy = true
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim' },
        },
        config = function()
            try_enable('julia', 'julials')
            try_enable('rust-analyzer', 'rust_analyzer')
            try_enable('lua-language-server', 'lua_ls')
            try_enable('texlab', 'texlab')
            try_enable('typescript-language-server', 'ts_ls')
            try_enable('basedpyright', 'basedpyright')
        end
    },
}

-- local prettier = {
--     formatCommand = [[prettierd --stdin-filepath ${INPUT} ${--tab-width:tab_width}]],
--     formatStdin = true,
-- }

local servers = {
    clangd = {},
    tsserver = {
        completions = {
            completefunctioncalls = true
        },
        -- languages = {
        --     typescript = { prettier },
        --     yaml = { prettier },
        -- },
    },
    -- eslint = {},
    lua_ls = {
        Lua = {
            telemetry = {
                enable = false
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                -- checkthirdparty = false,
                library = {
                    [vim.fn.expand("$vimruntime/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true,
                },
            },
        },
    },
}


require("mason").setup({
    ui = {
        border = "none",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    },
    log_level = vim.log.levels.info,
    max_concurrent_installers = 3,
})

require('mason-lspconfig').setup({
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = true,
})

require("lsp-format").setup({
    -- typescript = { tab_width = 2 },
    -- javascript = { tab_width = 2 },
    -- json = { tab_width = 2 },
})
-- Perform a sync version of format on :wq
vim.cmd([[cabbrev wq execute "Format sync" <bar> wq]])

local ok_lspconfig, lspconfig = pcall(require, 'lspconfig')
if not ok_lspconfig then
    print('ERROR: failed to require: lspconfig')
    return
end

local lsp_handlers = require('plugin_config.lsp_handlers')
lsp_handlers.setup()

for server, conf_opts in pairs(servers) do
    lspconfig[server].setup({
        on_attach = lsp_handlers.on_attach,
        capabilities = lsp_handlers.capabilities,
        settings = conf_opts,
    })
end


require('neodev').setup()


local ok, null_ls = pcall(require, 'null-ls')
if not ok then
    print('ERROR: failed to require: null-ls')
    return
end
null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd,
        -- null_ls.builtins.formatting.prettier.with({ extra_args = { '--single-quotes' } }),
        -- null_ls.builtins.formatting.prettier.with({ extra_args = { '--no-semi', '--single-quotes' } }),
        --null_ls.builtins.completion.spell,
    },
})

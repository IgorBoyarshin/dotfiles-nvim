local servers = {
    clangd = {},
    tsserver = {
        completions = {
            completefunctioncalls = true,
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
                enable = false,
            },
            diagnostics = {
                globals = { 'vim' },
            },
            workspace = {
                checkthirdparty = false,
                library = {
                    [vim.fn.expand('$vimruntime/lua')] = true,
                    [vim.fn.stdpath('config') .. '/lua'] = true,
                },
            },
        },
    },
}

require('mason').setup({
    ui = {
        border = 'none',
        icons = {
            package_installed = '✓',
            package_pending = '➜',
            package_uninstalled = '✗',
        },
    },
    log_level = vim.log.levels.info,
    max_concurrent_installers = 3,
})

require('mason-lspconfig').setup({
    ensure_installed = vim.tbl_keys(servers),
    automatic_installation = true,
})

-- Perform a sync version of format on :wq
-- vim.cmd([[cabbrev wq execute "Format sync" <bar> wq]])

local ok_lspconfig, lspconfig = pcall(require, 'lspconfig')
if not ok_lspconfig then
    print('ERROR: failed to require: lspconfig')
    return
end

local lsp_handlers = require('plugin_config.lsp_handlers')
lsp_handlers.setup()

for server, conf_opts in pairs(servers) do
    local commands = {}
    -- if server == 'tsserver' then
    --     commands = {
    --         OrganizeImports = {
    --             lsp_handlers.make_organize_imports_callback(0, 2000),
    --             description = 'Organize imports',
    --         },
    --     }
    -- end

    lspconfig[server].setup({
        on_attach = lsp_handlers.on_attach,
        capabilities = lsp_handlers.capabilities,
        settings = conf_opts,
        commands = commands,
    })
end

-- For lua language server
require('neodev').setup()

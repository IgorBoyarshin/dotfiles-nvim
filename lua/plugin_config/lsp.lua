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

require("lsp-format").setup({})
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

-- local async_formatting = function(bufnr)
--     bufnr = bufnr or vim.api.nvim_get_current_buf()
--
--     vim.lsp.buf_request(
--         bufnr,
--         "textDocument/formatting",
--         vim.lsp.util.make_formatting_params({}),
--         function(err, res, ctx)
--             if err then
--                 local err_msg = type(err) == "string" and err or err.message
--                 -- you can modify the log message / level (or ignore it completely)
--                 vim.notify("formatting: " .. err_msg, vim.log.levels.WARN)
--                 return
--             end
--
--             -- don't apply results if buffer is unloaded or has been modified
--             if not vim.api.nvim_buf_is_loaded(bufnr) or vim.api.nvim_buf_get_option(bufnr, "modified") then
--                 return
--             end
--
--             if res then
--                 local client = vim.lsp.get_client_by_id(ctx.client_id)
--                 vim.lsp.util.apply_text_edits(res, bufnr, client and client.offset_encoding or "utf-16")
--                 vim.api.nvim_buf_call(bufnr, function()
--                     vim.cmd("silent noautocmd update")
--                 end)
--             end
--         end
--     )
-- end
--
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    -- To format on save using the format() function, but not what the formatters offer on save
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePost", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- async_formatting(bufnr)
                    vim.lsp.buf.format({ timeout_ms = 2000 })
                end,
            })
        end
    end,
    sources = {
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.code_actions.eslint_d,
        -- null_ls.builtins.formatting.eslint_d,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettierd,
        -- null_ls.builtins.formatting.prettier.with({ extra_args = { '--single-quotes' } }),
        -- null_ls.builtins.formatting.prettier.with({ extra_args = { '--no-semi', '--single-quotes' } }),
        -- null_ls.builtins.completion.spell,
    },
})

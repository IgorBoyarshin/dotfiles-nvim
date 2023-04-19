local M = {}

function M.setup()
    local signs = {
        { name = 'DiagnosticSignError', text = '' },
        { name = 'DiagnosticSignWarn', text = '' },
        { name = 'DiagnosticSignHint', text = '' },
        { name = 'DiagnosticSignInfo', text = '' },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = '' })
    end

    vim.diagnostic.config({
        virtual_text = true, -- that annoying thing on the right with errors
        signs = {
            active = signs,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = 'minimal',
            border = 'rounded',
            source = 'always',
            header = '',
            prefix = '',
        },
    })

    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = 'rounded',
    })

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = 'rounded',
    })
end

-- local function lsp_highlight_document(client)
--     if client.server_capabilities.document_highlight then
--         vim.api.nvim_exec([[
--             augroup lsp_document_highlight
--                 autocmd! * <buffer>
--                 autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
--                 autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
--             augroup END
--         ]], false)
--     end
-- end

local function lsp_keymaps(bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end
        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = false })
    end
    -- nmap('<leader>F', vim.lsp.buf.format, 'LSP [F]ormat')

    -- vim.keymap.set('n', '<leader>F', function()
    --     local ok, res = pcall(vim.lsp.buf.format, '{ timeout_ms = 2000 }')
    -- end)

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('gR', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

    -- nmap('gl', vim.lsp.diagnostic.show_line_diagnostics({ border = 'rounded' }), 'Show [l]ine diagnostic')
    nmap('gl', function()
        vim.diagnostic.open_float()
    end, 'Show [l]ine diagnostic')
    nmap('[d', function()
        vim.diagnostic.goto_prev({ border = 'rounded' })
    end, 'Goto prev [d]iagnostic')
    nmap(']d', function()
        vim.diagnostic.goto_next({ border = 'rounded' })
    end, 'Goto next [d]iagnostic')
    nmap('<leader>l', function()
        vim.diagnostic.setloclist()
    end, 'Set [l]oclist')

    -- nmap('<leader>F', function()
    --     vim.lsp.buf.format({ timeout_ms = 2000 })
    -- end, '[F]ormat')

    nmap('<leader>V', function()
        vim.diagnostic.config({ virtual_text = true })
        print('Virtual text is now ON')
    end, 'Turn [V]isual text ON')
    nmap('<leader>v', function()
        vim.diagnostic.config({ virtual_text = false })
        print('Virtual text is now OFF')
    end, 'Turn [V]isual text OFF')

    -- vim.cmd([[ command! Format1 execute 'lua vim.lsp.buf.format({ timeout_ms = 2000 })' ]])

    -- nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    -- nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    -- nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('gh', vim.lsp.buf.hover, '[h]over documentation')
    nmap('gs', vim.lsp.buf.signature_help, '[s]ignature documentation')

    -- Lesser used LSP functionality
    -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    -- nmap('<leader>wl', function()
    --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    -- vim.api.nvim_buf_create_user_command(bufnr, 'Format2', function(_)
    --     vim.lsp.buf.format()
    -- end, { desc = 'Format current buffer with LSP' })
end

function M.on_attach(client, bufnr)
    -- require("lsp-format").on_attach(client)

    -- Use the dedicated plugin for formatting (formatter.nvim) and disallow
    -- all other ways just in case.
    client.server_capabilities.document_formatting = false
    -- if client.name == 'tsserver' then
    --     client.server_capabilities.document_formatting = false
    -- end

    lsp_keymaps(bufnr)
    -- lsp_highlight_document(client)
end

local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if not ok then
    print('ERROR: failed to require: cmp_nvim_lsp')
    return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

return M

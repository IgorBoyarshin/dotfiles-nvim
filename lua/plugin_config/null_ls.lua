local ok, null_ls = pcall(require, 'null-ls')
if not ok then
    error('Failed to require: null-ls')
    return
end

local null_ls_sources = {}

if vim.fn.executable('cspell') > 0 then
    table.insert(null_ls_sources, null_ls.builtins.code_actions.cspell)
    table.insert(
        null_ls_sources,
        null_ls.builtins.diagnostics.cspell.with({
            diagnostics_postprocess = function(diagnostic)
                diagnostic.severity = vim.diagnostic.severity.HINT
            end,
        })
    )
else
    error('"cspell" is not installed')
end

null_ls.setup({
    sources = null_ls_sources,
})

if vim.fn.executable('cspell') > 0 then
    if not require('settings').startup_spell_on then
        null_ls.disable({ 'cspell' }) -- disable cspell by default
    end

    vim.keymap.set('n', '<leader>S', function()
        require('null-ls').toggle({ 'cspell' })
        print('Toggled cspell')
    end, { desc = 'Toggle cspell' })
end

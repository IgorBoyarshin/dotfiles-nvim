---@diagnostic disable-next-line: unused-function, unused-local
local function fixed_organize_reports()
    local old_lines_count = #vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
    require('plugin_config.lsp_handlers').make_organize_imports_callback(0, 2000)()
    local new_lines_count = #vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)

    -- NOTE This is a hack to make sure the line count stays
    -- the same before and after this function's execution.
    -- This is required for the plugin's internal functionality not
    -- to throw an error.
    -- NOTE We can only remedy the decreased line count. The increased
    -- line count does not trigger the error because it represents
    -- a (sub)part of the buffer. Subsequent formatters do not seem to
    -- suffer from this, though.
    for _ = 1, (old_lines_count - new_lines_count) do
        -- Add an empty line at the end of the file(that will get removed
        -- by the default formatter at the very end)
        vim.api.nvim_buf_set_lines(0, -1, -1, false, { '' })
    end
end

require('formatter').setup({
    logging = false,
    -- log_level = vim.log.levels.WARN,
    filetype = { -- all are opt-in
        -- Formatters for each filetype will be executed in order

        lua = {
            -- require('formatter.filetypes.lua').stylua,
            function()
                -- if util.get_current_buffer_file_name() == 'special.lua' then
                --     return nil
                -- end

                return {
                    exe = 'stylua',
                    args = {
                        '--indent-type',
                        'Spaces',
                        '--quote-style',
                        'AutoPreferSingle',
                        '--search-parent-directories',
                        '--stdin-filepath',
                        require('formatter.util').escape_path(require('formatter.util').get_current_buffer_file_path()),
                        '--',
                        '-',
                    },
                    stdin = true,
                }
            end,
        },

        rust = {
            require('formatter.filetypes.rust').rustfmt,
        },

        javascript = {
            require('formatter.filetypes.javascript').eslint_d,
            require('formatter.filetypes.javascript').prettierd,
        },

        typescript = {
            -- fixed_organize_reports,
            require('formatter.filetypes.typescript').eslint_d,
            require('formatter.filetypes.typescript').prettierd,
        },

        -- For any filetype
        ['*'] = {
            require('formatter.filetypes.any').remove_trailing_whitespace,
        },
    },
})

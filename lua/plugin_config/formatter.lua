local util = require('formatter.util')
require('formatter').setup({
    logging = true,
    log_level = vim.log.levels.WARN,
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
                        util.escape_path(util.get_current_buffer_file_path()),
                        '--',
                        '-',
                    },
                    stdin = true,
                }
            end,
        },

        javascript = {
            require('formatter.filetypes.javascript').eslint_d,
            require('formatter.filetypes.javascript').prettierd,
        },

        typescript = {
            function()
                local old_lines_count = #vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
                require('plugin_config.lsp_handlers').make_organize_imports_callback(0, 2000)()
                local new_lines_count = #vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)

                -- NOTE This is a hack to make sure the line count stays
                -- the same before and after this function's execution.
                -- This is required for the plugin's internal functionality not
                -- to throw an error.
                -- NOTE We can only remedy the decreased line count. The increased
                -- line count does not trigger the error because it represents
                -- a part of the buffer. Subsequent formatters do not seem to
                -- suffer from this, though.
                for _ = 1, (old_lines_count - new_lines_count) do
                    vim.api.nvim_buf_set_lines(0, -1, -1, false, { '' })
                end
            end,
            require('formatter.filetypes.typescript').eslint_d,
            require('formatter.filetypes.typescript').prettierd,
        },

        -- For any filetype
        ['*'] = {
            require('formatter.filetypes.any').remove_trailing_whitespace,
        },
    },
})

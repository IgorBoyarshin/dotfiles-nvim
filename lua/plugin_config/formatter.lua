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
            require('formatter.filetypes.typescript').eslint_d,
            require('formatter.filetypes.typescript').prettierd,
        },

        -- For any filetype
        ['*'] = {
            require('formatter.filetypes.any').remove_trailing_whitespace,
        },
    },
})

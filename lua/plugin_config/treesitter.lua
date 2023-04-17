require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'lua', 'rust', 'vim', 'typescript', 'javascript',' json' },
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
    },
    indent = { enable = true, disable = { 'python' } },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<m-s>',
            node_incremental = '<m-s>',
            node_decremental = '<c-s>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                -- ['aa'] = '@parameter.outer',
                -- ['ia'] = '@parameter.inner',
                -- ['ac'] = '@class.outer',
                -- ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']f'] = '@function.outer',
                -- [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']F'] = '@function.outer',
                -- [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[f'] = '@function.outer',
                -- ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[F'] = '@function.outer',
                -- ['[]'] = '@class.outer',
            },
        },
        -- swap = {
        --     enable = true,
        --     swap_next = {
        --         ['<leader>a'] = '@parameter.inner',
        --     },
        --     swap_previous = {
        --         ['<leader>A'] = '@parameter.inner',
        --     },
        -- },
    },
}

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    'tpope/vim-fugitive',
    'tpope/vim-surround',
    'itchyny/vim-cursorword', -- underlines all occurances of word under cursor
    'lukas-reineke/indent-blankline.nvim',
    'nvim-lualine/lualine.nvim',
    {
        'kdheepak/lazygit.nvim',
        init = function()
            vim.keymap.set('n', '<leader>gl', '<cmd>LazyGit<cr>', { desc = '[g]it [l]azy' })
        end,
    },
    {
        'mbbill/undotree',
        init = function()
            vim.keymap.set('n', '<C-h>', vim.cmd.UndotreeToggle, { desc = '[h]istory undo tree' })
            vim.cmd([[
                let g:undotree_WindowLayout = 4
                let g:undotree_SetFocusWhenToggle = 1
            ]])
        end,
    },

    { 'terrortylor/nvim-comment', event = 'VeryLazy' },

    { 'nvim-tree/nvim-web-devicons', lazy = true },

    {
        'Raimondi/delimitMate',
        init = function()
            vim.cmd('let g:delimitMate_expand_cr = 1')
        end,
    },

    {
        'folke/which-key.nvim',
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },

    {
        'nvim-tree/nvim-tree.lua',
        event = 'VeryLazy',
        keys = {
            { '<C-d>', '<cmd>NvimTreeToggle<cr>', desc = 'NvimTree' },
        },
        opts = {
            view = {
                width = 40,
            },
            filters = {
                dotfiles = false,
            },
            renderer = {
                highlight_git = true, -- color the whole name according to git status
            },
            git = {
                ignore = false,
            },
        },
        init = function()
            -- Close NvimTree if it is the last open buffer
            vim.api.nvim_create_autocmd('BufEnter', {
                group = vim.api.nvim_create_augroup('NvimTreeClose', { clear = true }),
                pattern = 'NvimTree_*',
                callback = function()
                    local layout = vim.api.nvim_call_function('winlayout', {})
                    if
                        layout[1] == 'leaf'
                        and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), 'filetype') == 'NvimTree'
                        and layout[3] == nil
                    then
                        vim.cmd('confirm quit')
                    end
                end,
            })
        end,
    },

    {
        'folke/trouble.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        init = function()
            vim.keymap.set('n', '<leader>tt', '<cmd>TroubleToggle<cr>', { silent = true, desc = '[t]rouble [t]oggle' })
            vim.keymap.set(
                'n',
                '<leader>tw',
                '<cmd>TroubleToggle workspace_diagnostics<cr>',
                { silent = true, desc = '[t]rouble [w]orkspace diagnostics' }
            )
            vim.keymap.set(
                'n',
                '<leader>td',
                '<cmd>TroubleToggle document_diagnostics<cr>',
                { silent = true, desc = '[t]rouble [d]ocument diagnostics' }
            )
            vim.keymap.set(
                'n',
                '<leader>tl',
                '<cmd>TroubleToggle loclist<cr>',
                { silent = true, desc = '[t]rouble [l]oclist' }
            )
            vim.keymap.set(
                'n',
                '<leader>tq',
                '<cmd>TroubleToggle quickfix<cr>',
                { silent = true, desc = '[t]rouble [q]uickfix' }
            )
            vim.keymap.set(
                'n',
                'gr',
                '<cmd>TroubleToggle lsp_references<cr>',
                { silent = true, desc = 'trouble LSP [r]eferences' }
            )
        end,
    },

    {
        'lewis6991/gitsigns.nvim',
        event = 'VeryLazy',
        opts = {
            signs = {
                -- https://en.wikipedia.org/wiki/Block_Elements
                -- add = { text = '██' },
                -- change = { text = '██' },
                -- delete = { text = '██' },
                -- topdelete = { text = '██' },
                -- changedelete = { text = '██' },
                -- add = { text = ' ▎' },
                -- change = { text = ' ▎' },
                -- delete = { text = ' ▎' },
                -- topdelete = { text = ' ▎' },
                -- changedelete = { text = ' ▎' },
                add = { text = ' ▐' },
                change = { text = ' ▐' },
                delete = { text = ' ▐' },
                topdelete = { text = ' ▐' },
                changedelete = { text = ' ▐' },
            },
            on_attach = function()
                local gs = package.loaded.gitsigns

                vim.keymap.set('n', ']h', function()
                    if vim.wo.diff then
                        return ']h'
                    end
                    vim.schedule(function()
                        gs.next_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, desc = 'Next [h]unk' })

                vim.keymap.set('n', '[h', function()
                    if vim.wo.diff then
                        return '[h'
                    end
                    vim.schedule(function()
                        gs.prev_hunk()
                    end)
                    return '<Ignore>'
                end, { expr = true, desc = 'Prev [h]unk' })

                vim.keymap.set('n', '<leader>gs', ':Gitsigns stage_hunk<CR>', { desc = '[g]it [s]tage hunk' })
                vim.keymap.set('n', '<leader>gu', gs.undo_stage_hunk, { desc = '[g]it [u]ndo stage hunk' })
                vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { desc = '[g]it [p]review hunk' })
                vim.keymap.set('n', '<leader>gS', gs.stage_buffer, { desc = '[g]it [S]tage buffer' })
                -- vim.keymap.set("n", "<leader>gH", ":Gitsigns setqflist('all')<CR>",
                vim.keymap.set('n', '<leader>gH', function()
                    gs.setqflist('all')
                end, { desc = '[g]it list [H]unks' })
            end,
        },
    },

    {
        'EdenEast/nightfox.nvim',
        init = function()
            vim.cmd([[
                colorscheme duskfox

                highlight Todo gui=bold guifg=#ff1974 guibg=#232136

                highlight BufferCurrent guibg=#232136
                highlight BufferCurrentMod guibg=#232136
                highlight BufferInactive guibg=#090716
            ]])
        end,
    },

    -- {
    --     "lifepillar/vim-gruvbox8",
    --     init = function()
    --         vim.o.background = "dark"
    --         vim.cmd([[
    --             colorscheme gruvbox8_hard
    --
    --             highlight Normal guibg=#101418
    --             highlight Comment guifg=#726354
    --             highlight Todo gui=bold guifg=#ff1974 guibg=#101418
    --
    --             highlight GitGutterAdd guibg=#101418 guifg=#88eb26
    --             highlight GitGutterChange guibg=#101418 guifg=#d8db26
    --             highlight GitGutterDelete guibg=#101418
    --             highlight GitGutterChangeDelete guibg=#101418
    --
    --             " highlight BufferDefaultInactive guibg=#101418
    --             " highlight BufferDefaultCurrent guibg=#000408
    --             " highlight BufferInactive guibg=#101418
    --             " highlight BufferCurrent guibg=#000408
    --             " highlight TabLineFill guibg=#2c2826
    --         ]])
    --         vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
    --     end,
    -- },

    {
        'jose-elias-alvarez/null-ls.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- { 'williamboman/mason.nvim', config = true },
            { 'williamboman/mason.nvim', build = ':MasonUpdate' },
            'williamboman/mason-lspconfig.nvim',
            { 'j-hui/fidget.nvim', opts = {} },
            'folke/neodev.nvim', -- for lua language server
            -- "lukas-reineke/lsp-format.nvim",
            {
                'mhartington/formatter.nvim',
                init = function()
                    -- NOTE at the very least this plugin can remove whitespaces

                    vim.keymap.set('n', '<leader>F', '<cmd>Format<cr>', { desc = 'Format' })

                    vim.api.nvim_create_autocmd('BufWritePost', {
                        group = vim.api.nvim_create_augroup('FormatAutoGroup', { clear = true }),
                        command = 'FormatWrite',
                        desc = 'Format on file save',
                    })
                end,
            },
        },
    },

    -- {
    --     "jay-babu/mason-null-ls.nvim",
    --     event = { "BufReadPre", "BufNewFile" },
    --     dependencies = {
    --         "williamboman/mason.nvim",
    --         "jose-elias-alvarez/null-ls.nvim",
    --     },
    --     -- config = function()
    --     --     require("your.null-ls.config") -- require your null-ls config here (example below)
    --     -- end,
    -- },

    {
        'hrsh7th/nvim-cmp',
        dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
    },

    -- Fast alternative: fzf-lua
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },

    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
            return vim.fn.executable('make') == 1
        end,
    },

    -- Tabs
    {
        'romgrk/barbar.nvim',
        dependencies = 'nvim-tree/nvim-web-devicons',
        init = function()
            vim.g.barbar_auto_setup = false

            local map = vim.api.nvim_set_keymap
            local opts = { noremap = true, silent = true }

            -- Move to previous/next
            map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
            map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
            -- Re-order to previous/next
            map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
            map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
            -- Goto buffer in position...
            map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
            map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
            map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
            map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
            map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
            map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
            map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
            map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
            map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
            map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
            -- Pin/unpin buffer
            map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
            -- Close buffer
            map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
            map('n', '<A-C>', '<Cmd>BufferClose!<CR>', opts)
            -- Wipeout buffer
            --                 :BufferWipeout
            -- Close commands
            --                 :BufferCloseAllButCurrent
            --                 :BufferCloseAllButPinned
            --                 :BufferCloseAllButCurrentOrPinned
            --                 :BufferCloseBuffersLeft
            --                 :BufferCloseBuffersRight
            -- Magic buffer-picking mode
            map('n', '<A-b>', '<Cmd>BufferPick<CR>', opts)
        end,
        opts = {
            auto_hide = false,
            sidebar_filetypes = {
                -- Use the default values: {event = 'BufWinLeave', text = nil}
                NvimTree = true,
            },
        },
        -- version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },

    {
        'dstein64/vim-startuptime',
        cmd = 'StartupTime', -- lazy-load on a command
        init = function() -- init is called during startup. Configuration for vim plugins typically should be set in an init function
            vim.g.startuptime_tries = 10
        end,
    },
})

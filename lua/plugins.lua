local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)



require("lazy").setup({
    'tpope/vim-fugitive',
    'tpope/vim-surround',
    'itchyny/vim-cursorword', -- Highlight all occurances of word under cursor
    'lukas-reineke/indent-blankline.nvim',
    "nvim-lualine/lualine.nvim",

    { "terrortylor/nvim-comment", event = "VeryLazy" },

    { "nvim-tree/nvim-web-devicons", lazy = true },

    {
        'Raimondi/delimitMate',
        init = function()
            vim.cmd('let g:delimitMate_expand_cr = 1')
        end
    },

    {
        "folke/which-key.nvim",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end
    },

    {
        "nvim-tree/nvim-tree.lua",
        event = "VeryLazy",
        keys = {
            { "<C-d>", '<cmd>NvimTreeToggle<cr>', desc = "NvimTree" },
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
        },
        init = function()
            -- Close NvimTree if it is the last open buffer
            vim.api.nvim_create_autocmd("BufEnter", {
                group = vim.api.nvim_create_augroup("NvimTreeClose", {clear = true}),
                pattern = "NvimTree_*",
                callback = function()
                    local layout = vim.api.nvim_call_function("winlayout", {})
                    if layout[1] == "leaf" and vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(layout[2]), "filetype") == "NvimTree" and layout[3] == nil then vim.cmd("confirm quit") end
                end
            })
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
        },
    },

    {
        "lifepillar/vim-gruvbox8",
        init = function()
            vim.o.background = "dark"
            vim.cmd([[
                colorscheme gruvbox8_hard

                highlight Normal guibg=#101418
                highlight Comment guifg=#726354
                highlight Todo gui=bold guifg=#ff1974 guibg=#101418

                highlight GitGutterAdd guibg=#101418 guifg=#88db26
                highlight GitGutterChange guibg=#101418 guifg=#e8db26
                highlight GitGutterDelete guibg=#101418
                highlight GitGutterChangeDelete guibg=#101418

                " highlight BufferDefaultInactive guibg=#101418
                " highlight BufferDefaultCurrent guibg=#000408
                " highlight BufferInactive guibg=#101418
                " highlight BufferCurrent guibg=#000408
                " highlight TabLineFill guibg=#2c2826
            ]])
            vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
        end,
    },

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
            'folke/neodev.nvim',
        },
    },

    {
        'hrsh7th/nvim-cmp',
        dependencies = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
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
            return vim.fn.executable 'make' == 1
        end,
    },

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
            -- Wipeout buffer
            --                 :BufferWipeout
            -- Close commands
            --                 :BufferCloseAllButCurrent
            --                 :BufferCloseAllButPinned
            --                 :BufferCloseAllButCurrentOrPinned
            --                 :BufferCloseBuffersLeft
            --                 :BufferCloseBuffersRight
            -- Magic buffer-picking mode
            map('n', '<A-m>', '<Cmd>BufferPick<CR>', opts)
        end,
        opts = {
            auto_hide = true,
            sidebar_filetypes = {
                -- Use the default values: {event = 'BufWinLeave', text = nil}
                NvimTree = true,
            },
        },
        -- version = '^1.0.0', -- optional: only update when a new 1.x version is released
    },

    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime", -- lazy-load on a command
        init = function() -- init is called during startup. Configuration for vim plugins typically should be set in an init function
            vim.g.startuptime_tries = 10
        end,
    },
})

local builtin = require("telescope.builtin")

local function fuzzyFindFiles()
    builtin.grep_string({
        path_display = { "smart" },
        only_sort_text = true,
        word_match = "-w",
        search = "",
    })
end

vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "fuzzy find files" })
-- vim.keymap.set('n', '<C-f>', builtin.live_grep, {}) -- not fuzzy
vim.keymap.set("n", "<C-f>", fuzzyFindFiles, { desc = "fuzzy find contents" })
vim.keymap.set("n", "<leader>h", builtin.help_tags, { desc = "search help" })
vim.keymap.set("n", "<leader>b", builtin.buffers, { desc = "list open buffers" })
vim.keymap.set("n", "<leader>q", builtin.quickfix, { desc = "open quickfix" })
vim.keymap.set("n", "<leader>l", builtin.loclist, { desc = "open loclist" })
-- vim.keymap.set('n', '<leader>/', function()
--     require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
--         winblend = 10,
--         previewer = false,
--     })
-- end, { desc = '[/] Fuzzily search in current buffer' })

require("telescope").setup({
    -- extensions_list = { "themes", "terms" },
    defaults = {
        vimgrep_arguments = {
            "rg",
            "-L",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
        },
        prompt_prefix = "   ",
        selection_caret = "  ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                prompt_position = "top",
                preview_width = 0.55,
                results_width = 0.8,
            },
            vertical = {
                mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
        },
        file_sorter = require("telescope.sorters").get_fuzzy_file,
        file_ignore_patterns = { "node_modules" },
        generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
        path_display = { "truncate" },
        winblend = 0,
        border = {},
        borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        file_previewer = require("telescope.previewers").vim_buffer_cat.new,
        grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
        qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
        -- Developer configurations: Not meant for general override
        buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
        mappings = {
            i = {
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
                ["<C-u>"] = false,
                ["<C-d>"] = false,
                ["<esc>"] = require("telescope.actions").close,
                ["<C-q>"] = require("telescope.actions").smart_send_to_qflist,
            },
        },
    },
})

-- Enable telescope fzf native, if installed
pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "themes")
pcall(require("telescope").load_extension, "terms")

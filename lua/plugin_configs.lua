require('indent_blankline').setup({
    show_trailing_blankline_indent = false,
    vim.cmd([[
        let g:indent_blankline_show_first_indent_level = v:false 
        let g:indent_blankline_char_list = ['|', '¦', '┆', '┊'] 
        let g:indentLine_color_term = 239
        let g:vim_json_conceal = 0
        let g:markdown_syntax_conceal = 0
    ]])
})


require('which-key').setup({})


require('nvim_comment').setup({
    line_mapping = "<C-/><C-/>", -- normal mode
    operator_mapping = "<C-/>", -- visual mode
})

require('plugin_config.lualine')
require('plugin_config.treesitter')
require('plugin_config.lsp')
require('plugin_config.telescope')

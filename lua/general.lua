-- Disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set termguicolors to enable highlight groups
vim.opt.termguicolors = true

vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.number = true
vim.opt.showcmd = true
vim.opt.autoread = true
vim.opt.scrolloff = 5
vim.opt.laststatus = 2
vim.opt.swapfile = false
vim.opt.clipboard:append('unnamedplus')
vim.opt.mouse = 'a'

-- Make the search case insensitive, but switch to sensitive when there is a
-- capital letter in the search pattern.
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Display Tab and Eol chars
vim.opt.list = true
vim.opt.listchars = {
    tab = '>~',
    --eol = '¬',
}

-- Tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 0 -- when backspacing, delete by spaces, not by tabs
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.cmd([[
augroup typescriptindent
  autocmd FileType typescript setlocal tabstop=2
  autocmd FileType typescript setlocal shiftwidth=2
augroup END

augroup javascriptindent
  autocmd FileType javascript setlocal tabstop=2
  autocmd FileType javascript setlocal shiftwidth=2
augroup END
]])

vim.opt.colorcolumn = '80'

vim.cmd([[
    " Highlight them as TODO
    match Todo /\<NOTE\>\|\<WTF\>\|\<TODO\>\|\<FIX\>\|\<XXX\>\|\<nocheckin\>\|\<FIXME\>/

    " Allow color schemes to do bright colors without forcing bold.
    if &t_Co == 8 && $TERM !~# '^linux\|^Eterm'
        set t_Co=16
    endif
]])

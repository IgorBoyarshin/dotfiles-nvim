vim.keymap.set(
    'n',
    '<leader>r',
    '<cmd>source ~/.config/nvim/init.lua<cr> <cmd>echo "init.lua reloaded!"<cr>',
    { desc = '[r]eload init.lua' }
)

vim.keymap.set('n', '<leader>cs', function()
    pcall(vim.cmd, ':%s/\\s*$//<C-l>')
    print('Cleared all trailing whitespaces from the buffer!')
end, { desc = '[c]lear trailing [s]paces' })
vim.keymap.set('n', '<leader>cm', function()
    local _, _ = pcall(vim.cmd, ':%s/\\r//')
    print('Cleared all ^M from the buffer!')
end, { desc = '[c]lear ^M symbols' })

vim.keymap.set('n', 'gP', 'O<Esc>Vp<cmd>let @+ = @0<cr>')
vim.keymap.set('n', 'gp', 'o<Esc>Vp<cmd>let @+ = @0<cr>')

vim.keymap.set('n', 'gO', 'O<Esc>j')
vim.keymap.set('n', 'g<C-o>', 'o<Esc>k')

vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('n', '<Space>', 'i<Space><Esc>')
vim.keymap.set('n', '<CR>', 'a<Space><Esc>')

vim.keymap.set('n', '<up>', 'ddkP')
vim.keymap.set('n', '<down>', 'ddp')
vim.keymap.set('n', '<right>', 'xp')
vim.keymap.set('n', '<left>', 'xhP')

-- Disable until we know we need it
-- vim.keymap.set('n', '<C-K>', 'K')

vim.keymap.set('n', '<C-j>', 'J')
vim.keymap.set('n', '<C-k>', 'kJ')

vim.keymap.set('n', 'H', '^')
vim.keymap.set('n', 'L', '$')
vim.keymap.set('n', 'J', '5j')
vim.keymap.set('n', 'K', '5k')
vim.keymap.set('v', 'H', '^')
vim.keymap.set('v', 'L', '$')
vim.keymap.set('v', 'J', '5j')
vim.keymap.set('v', 'K', '5k')

-- Fix accidental unwanted unrecoverable deletion while in insert mode
vim.keymap.set('i', '<C-u>', '<C-g>u<C-u>')
vim.keymap.set('i', '<C-w>', '<C-g>u<C-w>')

-- Paste without overriding the buffer
-- gv highlights whatever was previously selected
vim.keymap.set('v', 'p', 'pgvy')

-- Spell checking
-- To correct using suggestions: z=
vim.keymap.set('n', '<F5>', function()
    local _, _ = pcall(vim.cmd, ':setlocal spell! spelllang=en<CR>')
    print('Toggled spellcheck language = EN')
end)
vim.keymap.set('n', '<F6>', function()
    local _, _ = pcall(vim.cmd, ':setlocal spell! spelllang=ru<CR>')
    print('Toggled spellcheck language = RU')
end)
vim.keymap.set('n', '<F7>', function()
    local _, _ = pcall(vim.cmd, ':setlocal spell! spelllang=uk<CR>')
    print('Toggled spellcheck language = UKR')
end)

-- vim.keymap.set('n', '<leader>hg', function()
--     -- vim.cmd([[
--     local ok, res = pcall(vim.cmd, [[
--         nmap <leader>sp :call <SID>SynStack()<CR>
--         function! SynStack()
--             if !exists("*synstack")
--                 return
--             endif
--             echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
--         endfunc
--     ]])
--     -- if not ok then
--     --     print('Failed')
--     -- end
-- end)

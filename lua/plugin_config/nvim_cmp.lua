require('luasnip').config.setup({})

local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        -- ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete({}),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false, -- whether <CR> accepts the first match
        }),
        ['<C-j>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            -- elseif luasnip.expand_or_jumpable() then
            --     luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-k>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            -- elseif luasnip.jumpable(-1) then
            --     luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    -- Order of priority in which the auto-complete suggestions will appear
    sources = {
        { name = 'nvim_lsp' },
        {
            name = 'buffer',
            option = {
                -- keyword_length = 2,
            },
        },
        -- { name = 'cmdline' }, -- causes E481
        { name = 'path' },
        -- { name = 'luasnip' },
        -- { name = 'omni' },
    },
})

cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' },
    },
})

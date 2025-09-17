-- Auto completion and code snippets
return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'onsails/lspkind-nvim',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lsp',
      {
        'L3MON4D3/LuaSnip',
        version = 'v2.*',
        build = 'make install_jsregexp',
      },
    },
    init = function()
      local cmp = require 'cmp'
      local lspkind = require 'lspkind'
      local ls = require 'luasnip'
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api
              .nvim_buf_get_lines(0, line - 1, line, true)[1]
              :sub(col, col)
              :match '%s'
            == nil
      end

      vim.keymap.set({ 'i', 's' }, '<Tab>', function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif ls.expand_or_jumpable() then
          ls.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes('<Tab>', true, true, true),
            'n',
            true
          )
        end
      end)

      vim.keymap.set({ 'i', 's' }, '<S-Tab>', function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          ls.jump(-1)
        end
      end, { silent = true })

      cmp.setup {
        snippet = {
          expand = function(args)
            ls.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-f>'] = function()
            ls.jump(1)
          end,
          ['<C-b>'] = function()
            ls.jump(-1)
          end,
          ['<C-e>'] = cmp.mapping.abort(),
          ['<C-y>'] = cmp.mapping.confirm { select = true },
          ['<C-Space>'] = cmp.mapping.complete(),
        },
        sources = {
          { name = 'codeium' },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
        },
        preselect = 'item',
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        formatting = {
          format = lspkind.cmp_format { symbol_map = { Codeium = '' } },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
      }
    end,
  },
}

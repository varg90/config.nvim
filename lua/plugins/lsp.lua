return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      {
        'mason-org/mason-lspconfig.nvim',
        opts = {
          ensure_installed = {
            'ts_ls',
            'eslint',
            'tailwindcss',
            'lua_ls',
            'emmet_ls',
          },
          automatic_enable = true,
        },
      },
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      local capabilities = vim.tbl_deep_extend(
        'force',
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
      )

      -- Apply capabilities to all servers
      vim.lsp.config('*', { capabilities = capabilities })

      -- ruby_lsp is not managed by mason — enable it manually with rbenv bundle
      vim.lsp.config('ruby_lsp', {
        cmd = vim.uv.fs_stat(vim.loop.cwd() .. '/Gemfile')
          and { vim.env.HOME .. '/.rbenv/shims/bundle', 'exec', 'ruby-lsp' }
          or { vim.fn.exepath 'ruby-lsp' },
      })
      vim.lsp.enable('ruby_lsp')

      vim.lsp.config('lua_ls', {
        settings = {
          Lua = { completion = { callSnippet = 'Replace' } },
        },
      })

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local opts = function(desc)
            return { buffer = bufnr, remap = false, desc = desc }
          end

          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts '[LSP] Go to definition')
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts '[LSP] Hover')
          vim.keymap.set('n', 'gs', vim.lsp.buf.references, opts '[LSP] Show references')
          vim.keymap.set('n', 'gi', vim.lsp.buf.type_definition, opts '[LSP] Type definition')
          vim.keymap.set({ 'n', 'v' }, '<leader>va', vim.lsp.buf.code_action, opts '[LSP] Code actions')
          vim.keymap.set('n', '<leader>vws', vim.lsp.buf.workspace_symbol, opts '[LSP] Workspace symbol')
          vim.keymap.set('n', '<leader>vh', vim.diagnostic.open_float, opts '[LSP] Open float')
          vim.keymap.set('n', '<leader>ve', vim.lsp.buf.references, opts '[LSP] References')
          vim.keymap.set('n', 'gr', vim.lsp.buf.rename, opts '[LSP] Rename')
          vim.keymap.set('i', '<c-h>', vim.lsp.buf.signature_help, opts '[LSP] Signature help')
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts '[LSP] Go to declaration')
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            return diagnostic.message
          end,
        },
      }
    end,
  },
}

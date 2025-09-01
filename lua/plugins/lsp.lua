return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'mason-org/mason.nvim',
        opts = {
          ensure_installed = {
            'prettier',
            'solargraph',
            'eslint',
            'tailwindcss',
            'ts_ls',
          },
        },
      },
      {
        'mason-org/mason-lspconfig.nvim',
        opts = { ensure_installed = { 'solargraph', 'eslint' } },
      },
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup(
          'kickstart-lsp-attach',
          { clear = true }
        ),
        callback = function(event)
          local bufnr = event.buf

          vim.keymap.set(
            'n',
            'gd',
            vim.lsp.buf.definition,
            { buffer = bufnr, remap = false, desc = '[LSP] Go to definition' }
          )
          vim.keymap.set(
            'n',
            'K',
            vim.lsp.buf.hover,
            { buffer = bufnr, remap = false, desc = '[LSP] Hover' }
          )
          vim.keymap.set(
            'n',
            'gs',
            vim.lsp.buf.references,
            { buffer = bufnr, remap = false, desc = '[LSP] Finder' }
          )
          vim.keymap.set(
            'n',
            'gi',
            vim.lsp.buf.type_definition,
            { buffer = bufnr, remap = false, desc = '[LSP] Hover doc' }
          )
          vim.keymap.set(
            { 'n', 'v' },
            '<leader>va',
            vim.lsp.buf.code_action,
            { buffer = bufnr, remap = false, desc = '[LSP] Code actions' }
          )
          vim.keymap.set(
            'n',
            '<leader>vws',
            function()
              vim.lsp.buf.workspace_symbol()
            end,
            { buffer = bufnr, remap = false, desc = '[LSP] Workspace symbol' }
          )
          vim.keymap.set('n', '<leader>vh', function()
            vim.diagnostic.open_float()
          end, {
            buffer = bufnr,
            remap = false,
            desc = '[LSP] Open float',
          })
          vim.keymap.set('n', '[d', function()
            vim.diagnostic.goto_next()
          end, {
            buffer = bufnr,
            remap = false,
            desc = '[LSP] Goto next',
          })
          vim.keymap.set('n', ']d', function()
            vim.diagnostic.goto_prev()
          end, {
            buffer = bufnr,
            remap = false,
            desc = '[LSP] Goto prev',
          })
          vim.keymap.set('n', '<leader>ve', function()
            vim.lsp.buf.references()
          end, {
            buffer = bufnr,
            remap = false,
            desc = '[LSP] References',
          })
          vim.keymap.set('n', 'gr', function()
            vim.lsp.buf.rename()
          end, { buffer = bufnr, remap = false, desc = '[LSP] Rename' })
          vim.keymap.set('i', '<c-h>', function()
            vim.lsp.buf.signature_help()
          end, {
            buffer = bufnr,
            remap = false,
            desc = '[LSP] Signature help',
          })
          vim.keymap.set(
            'n',
            '<leader>vo',
            function()
              vim.lsp.buf.execute_command {
                command = '_typescript.organizeImports',
                arguments = { vim.fn.expand '%:p' },
              }
            end,
            { buffer = bufnr, remap = false, desc = '[LSP] Organize imports' }
          )
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
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local servers = {
        solargraph = {
          cmd = (function()
            local util = require 'lspconfig.util'
            local root = vim.fn.getcwd()
            if util.path.exists(util.path.join(root, 'Gemfile')) then
              return { 'bundle', 'exec', 'solargraph', 'stdio' }
            else
              return { 'solargraph', 'stdio' }
            end
          end)(),
          settings = {
            solargraph = {
              diagnostics = true,
              formatting = true,
              completion = true,
              useBundler = false,
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
      })

      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      require('mason-lspconfig').setup {
        ensure_installed = {
          'ts_ls',
          'eslint',
          'tailwindcss',
          'ember',
          'rust_analyzer',
          'lua_ls',
          'solargraph',
          'emmet_ls',
          'elixirls',
        },
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}

            server.capabilities = vim.tbl_deep_extend(
              'force',
              {},
              capabilities,
              server.capabilities or {}
            )
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
}

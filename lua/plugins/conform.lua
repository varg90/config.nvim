return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format {
          async = true,
          lsp_fallback = true,
          lsp_format = 'fallback',
        }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    log_level = vim.log.levels.DEBUG,
    notify_on_error = true,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- ensure to install gem erb-formatter for the erb_format binary command
      eruby = { 'erb_format' },
      ruby = { 'prettierd' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      css = { 'prettierd' },
      json = { 'prettierd' },
      jsonc = { 'prettier' },
      conf = { 'prettier' },
      python = { 'ruff_format', 'ruff_fix' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
    formatters = {
      prettier = {
        contition = false,
        command = 'prettier',
        args = { '--stdin-filepath', '$FILENAME' },
        stdin = true,
      },
    },
    -- Set up format-on-save
    format_on_save = true,
  },
}

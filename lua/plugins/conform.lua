return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    log_level = vim.log.levels.DEBUG,
    notify_on_error = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      html = { 'prettier' },
      ruby = { 'prettierd' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      css = { 'prettierd' },
      json = { 'prettierd' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
    formatters = {
      prettier = {
        command = 'prettier',
        args = { '--stdin-filepath', '$FILENAME' },
        stdin = true,
      },
      prettierd = {
        condition = function(context)
          local filename = context.filename or ''
          return filename:match '%.rb$'
            or filename:match '%.js$'
            or filename:match '%.ts$'
            or filename:match '%.css$'
            or filename:match '%.json$'
            or filename:match '%.erb'
        end,
      },
    },
    -- Set up format-on-save
    format_on_save = false,
  },
  config = function(_, opts)
    require('conform').setup(opts)

    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = {
        '*.rb',
        '*.js',
        '*.ts',
        '*.css',
        '*.json',
        '*.lua',
        '*.erb',
        '*.html',
      },
      callback = function(args)
        require('conform').format {
          bufnr = args.buf,
          async = false,
          lsp_fallback = true,
        }
      end,
    })
  end,
}

return {
  {
    'tpope/vim-fugitive',
    config = function()
      vim.keymap.set(
        'n',
        '<leader>gb',
        ':Git blame<CR>',
        { desc = '[G]it [B]lame' }
      )
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup {
        signs = {
          add = { text = '│' },
          change = { text = '│' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
        numhl = true,
        current_line_blame_opts = {
          virt_text_pos = 'eol',
          delay = 1000,
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(gs.next_hunk)
            return '<Ignore>'
          end, { expr = true, desc = '[GIT] Next hunk' })

          map('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(gs.prev_hunk)
            return '<Ignore>'
          end, { expr = true, desc = '[GIT] Prev hunk' })

          -- Hunk actions
          map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = '[GIT] Stage hunk' })
          map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = '[GIT] Reset hunk' })
          map('n', '<leader>hS', gs.stage_buffer, { desc = '[GIT] Stage buffer' })
          map('n', '<leader>hu', gs.undo_stage_hunk, { desc = '[GIT] Undo stage hunk' })
          map('n', '<leader>hR', gs.reset_buffer, { desc = '[GIT] Reset buffer' })
          map('n', '<leader>gp', gs.preview_hunk, { desc = '[GIT] Preview hunk' })
          map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = '[GIT] Blame line' })
          map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = '[GIT] Toggle inline blame' })
          map('n', '<leader>hd', gs.diffthis, { desc = '[GIT] Diff this' })
          map('n', '<leader>hD', function() gs.diffthis '~' end, { desc = '[GIT] Diff this (cached)' })

          -- Text object
          map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = '[GIT] Select hunk' })

          -- Open current line/selection on GitHub
          map({ 'n', 'v' }, '<leader>go', function()
            local git_info = vim.fn.systemlist 'git rev-parse --show-toplevel --abbrev-ref HEAD 2>/dev/null && git remote get-url origin 2>/dev/null'
            if #git_info < 3 then
              print 'Not a git repository or no remote origin'
              return
            end
            local repo_root, branch, remote_url = git_info[1], git_info[2], git_info[3]
            local relpath = vim.fn.expand('%:p'):sub(#repo_root + 2)
            remote_url = remote_url:gsub('^git@github.com:', 'https://github.com/'):gsub('%.git$', '')
            if branch == 'HEAD' then
              branch = vim.fn.systemlist('git rev-parse HEAD')[1]
            end
            local remote_check = vim.fn.systemlist('git ls-remote --heads origin ' .. branch .. ' 2>/dev/null')
            if #remote_check == 0 or remote_check[1] == '' then
              local has_master = vim.fn.systemlist 'git ls-remote --heads origin master 2>/dev/null'
              branch = (#has_master > 0 and has_master[1] ~= '') and 'master' or 'main'
            end
            local url
            if vim.fn.mode() == 'v' or vim.fn.mode() == 'V' then
              local s, e = vim.fn.line 'v', vim.fn.line '.'
              if s > e then s, e = e, s end
              url = string.format('%s/blob/%s/%s#L%d-L%d', remote_url, branch, relpath, s, e)
            else
              url = string.format('%s/blob/%s/%s#L%d', remote_url, branch, relpath, vim.fn.line '.')
            end
            local opener = vim.fn.has 'macunix' == 1 and 'open' or (vim.fn.has 'win32' == 1 and 'start' or 'xdg-open')
            vim.fn.jobstart({ opener, url }, { detach = true })
            print('Opening ' .. url)
          end, { desc = '[GIT] Open on GitHub' })
        end,
      }
    end,
  },
}

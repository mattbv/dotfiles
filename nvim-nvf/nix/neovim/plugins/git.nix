# Gitsigns: git status in the gutter + hunk management
# Translated from nvim/lua/config/plugins/git.lua
#
# NVF provides vim.git.gitsigns with declarative mappings, but the original
# config uses a complex on_attach with expr mappings (]c/[c that check
# vim.wo.diff), visual mode hunk stage/reset, and text objects. We pass
# these through setupOpts.on_attach as raw Lua.
{lib, ...}: {
  config.vim.git = {
    enable = true;

    gitsigns = {
      enable = true;

      # Disable NVF's default gitsigns keymaps -- we define them in on_attach
      mappings = {
        blameLine = null;
        diffProject = null;
        diffThis = null;
        nextHunk = null;
        previewHunk = null;
        previousHunk = null;
        resetBuffer = null;
        resetHunk = null;
        stageBuffer = null;
        stageHunk = null;
        toggleBlame = null;
        toggleDeleted = null;
        undoStageHunk = null;
      };

      setupOpts = {
        signs = {
          add.text = "+";
          change.text = "~";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
        };

        on_attach = lib.generators.mkLuaInline ''
          function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation (expr mappings that respect diff mode)
            map({ 'n', 'v' }, ']c', function()
              if vim.wo.diff then return ']c' end
              vim.schedule(function() gs.next_hunk() end)
              return '<Ignore>'
            end, { expr = true, desc = 'Jump to next hunk' })

            map({ 'n', 'v' }, '[c', function()
              if vim.wo.diff then return '[c' end
              vim.schedule(function() gs.prev_hunk() end)
              return '<Ignore>'
            end, { expr = true, desc = 'Jump to previous hunk' })

            -- Actions (visual mode)
            map('v', '<leader>hs', function()
              gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
            end, { desc = 'stage git hunk' })
            map('v', '<leader>hr', function()
              gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
            end, { desc = 'reset git hunk' })

            -- Actions (normal mode)
            map('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' })
            map('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' })
            map('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' })
            map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' })
            map('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' })
            map('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' })
            map('n', '<leader>hb', function()
              gs.blame_line { full = false }
            end, { desc = 'git blame line' })
            map('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' })
            map('n', '<leader>hD', function()
              gs.diffthis '~'
            end, { desc = 'git diff against last commit' })

            -- Toggles
            map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' })
            map('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' })

            -- Text object
            map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' })
          end
        '';
      };
    };
  };
}

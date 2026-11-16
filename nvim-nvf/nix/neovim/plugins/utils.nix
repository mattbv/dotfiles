# Utility plugins: harpoon, todo-comments, marks.nvim, which-key
# Translated from nvim/lua/config/plugins/utils.lua
{pkgs, lib, ...}: {
  config.vim = {
    # -- Harpoon 2: quick file navigation --
    navigation.harpoon = {
      enable = true;
      setupOpts = {};

      # NVF harpoon mappings (these map to <leader><key> format)
      # We null them out and define our own with exact key combos
      mappings = {
        markFile = null;
        listMarks = null;
        file1 = null;
        file2 = null;
        file3 = null;
        file4 = null;
      };
    };

    # -- Todo-comments: highlight TODO, FIXME, etc. --
    notes.todo-comments = {
      enable = true;
      setupOpts = {};
    };

    # -- Which-key: show pending keybinds --
    binds.whichKey = {
      enable = true;
      setupOpts = {
        preset = "classic";
      };
      # Register key group labels
      register = {
        "<leader>c" = "[C]ode";
        "<leader>d" = "[D]ocument";
        "<leader>r" = "[R]ename";
        "<leader>s" = "[S]earch";
        "<leader>w" = "[W]orkspace";
        "<leader>t" = "[T]oggle";
        "<leader>h" = "Git [H]unk";
      };
    };

    # which-key visual mode group registration via raw Lua
    # (NVF's register attrset doesn't support per-mode registration)
    luaConfigRC.whichkey-groups = ''
      local ok, wk = pcall(require, 'which-key')
      if ok then
        wk.add {
          { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        }
      end
    '';

    # -- marks.nvim: show marks in the sign column --
    extraPlugins = {
      marks-nvim = {
        package = pkgs.vimPlugins.marks-nvim;
        setup = ''
          require('marks').setup {}
        '';
      };
    };

    # Harpoon keymaps via raw Lua (NVF's declarative mappings don't support
    # the harpoon:list() method call pattern)
    luaConfigRC.harpoon-keymaps = ''
      local harpoon = require 'harpoon'
      vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = 'Harpoon add file' })
      vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon menu' })
      vim.keymap.set('n', '<C-h>', function() harpoon:list():select(1) end, { desc = 'Harpoon file 1' })
      vim.keymap.set('n', '<C-t>', function() harpoon:list():select(2) end, { desc = 'Harpoon file 2' })
      vim.keymap.set('n', '<C-n>', function() harpoon:list():select(3) end, { desc = 'Harpoon file 3' })
      vim.keymap.set('n', '<C-s>', function() harpoon:list():select(4) end, { desc = 'Harpoon file 4' })
      vim.keymap.set('n', '<C-S-P>', function() harpoon:list():prev() end, { desc = 'Harpoon previous' })
      vim.keymap.set('n', '<C-S-N>', function() harpoon:list():next() end, { desc = 'Harpoon next' })
    '';
  };
}

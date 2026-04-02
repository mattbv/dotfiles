# mini.nvim modules: ai, surround, pairs, cursorword, comment, move
# Translated from nvim/lua/config/plugins/mini.lua
{lib, ...}: {
  config.vim.mini = {
    # Better Around/Inside textobjects
    ai = {
      enable = true;
      setupOpts.n_lines = 500;
    };

    # Add/delete/replace surroundings (brackets, quotes, etc.)
    surround = {
      enable = true;
      setupOpts = {};
    };

    # Auto-pair brackets, quotes, etc.
    pairs = {
      enable = true;
      setupOpts = {};
    };

    # Highlight word under cursor
    cursorword = {
      enable = true;
      setupOpts = {};
    };

    # Comment with gc
    comment = {
      enable = true;
      setupOpts = {};
    };

    # Move lines/selections with Alt+hjkl
    move = {
      enable = true;
      setupOpts = {
        mappings = {
          left = "<M-h>";
          down = "<M-j>";
          right = "<M-l>";
          up = "<M-k>";
          line_left = "<M-h>";
          line_right = "<M-l>";
          line_down = "<M-j>";
          line_up = "<M-k>";
        };
        options = {
          reindent_linewise = true;
        };
      };
    };

    # mini.icons for Oil and other plugins
    icons = {
      enable = true;
      setupOpts = {};
    };
  };

  # Custom highlight overrides for mini.cursorword
  config.vim.luaConfigRC.mini-highlights = ''
    vim.cmd 'hi! link MiniCursorword Visual'
    vim.cmd 'hi! MiniCursorwordCurrent gui=nocombine guifg=NONE guibg=NONE'
  '';
}

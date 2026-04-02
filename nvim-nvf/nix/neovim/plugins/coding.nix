# Coding plugins: refactoring, ssr, outline, treesitter-context
# Translated from nvim/lua/config/plugins/coding.lua
{pkgs, ...}: {
  config.vim = {
    # Treesitter-context: show current scope at top of buffer
    treesitter.context.enable = true;

    extraPlugins = {
      # refactoring.nvim
      refactoring-nvim = {
        package = pkgs.vimPlugins.refactoring-nvim;
        setup = ''
          require('refactoring').setup {}
        '';
      };

      # ssr.nvim: structural search and replace
      ssr-nvim = {
        package = pkgs.vimPlugins.ssr-nvim;
        setup = '''';
      };

      # outline.nvim: code outline sidebar
      outline-nvim = {
        package = pkgs.vimPlugins.outline-nvim;
        setup = ''
          require('outline').setup {}
        '';
      };
    };

    keymaps = [
      {
        key = "<leader>cR";
        mode = "v";
        action = "function() require('refactoring').select_refactor() end";
        lua = true;
        desc = "Refactor";
      }
      {
        key = "<leader>sR";
        mode = ["n" "x"];
        action = "function() require('ssr').open() end";
        lua = true;
        desc = "Structural Replace";
      }
      {
        key = "<leader>so";
        mode = "n";
        action = "<cmd>Outline<CR>";
        desc = "Toggle outline";
      }
    ];
  };
}

# Catppuccin Mocha theme with transparency
# Translated from nvim/lua/config/plugins/colorscheme.lua and ui.lua (transparent.nvim)
{pkgs, ...}: {
  config.vim = {
    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
      transparent = true;

      # Catppuccin integration flags (injected before theme setup)
      extraConfig = ''
        require('catppuccin').setup {
          flavour = 'mocha',
          background = {
            light = 'latte',
            dark = 'mocha',
          },
          integrations = {
            telescope = true,
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            treesitter = true,
            notify = true,
            mini = {
              enabled = true,
              indentscope_color = "",
            },
          },
        }
      '';
    };

    # transparent.nvim for full transparency support beyond what the theme provides
    extraPlugins = {
      transparent-nvim = {
        package = pkgs.vimPlugins.transparent-nvim;
        setup = ''
          require('transparent').setup {
            groups = {
              'Normal', 'NormalNC', 'Comment', 'Constant', 'Special',
              'Identifier', 'Statement', 'PreProc', 'Type', 'Underlined',
              'Todo', 'String', 'Function', 'Conditional', 'Repeat',
              'Operator', 'Structure', 'LineNr', 'NonText', 'SignColumn',
              'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
              'EndOfBuffer',
            },
            extra_groups = { 'Oil' },
            exclude_groups = {},
            on_clear = function() end,
          }
        '';
      };
    };
  };
}

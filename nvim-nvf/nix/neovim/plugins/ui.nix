# UI plugins: oil.nvim, indent-blankline, lualine, symbol-usage
# Translated from nvim/lua/config/plugins/ui.lua
# NOTE: transparent.nvim is in theme.nix, copilot-lualine is in Phase 5 (ai.nix)
{pkgs, lib, ...}: {
  config.vim = {
    # -- Oil: file explorer as a buffer --
    utility.oil-nvim = {
      enable = true;
      setupOpts = {
        columns = ["icon"];
        view_options = {
          show_hidden = true;
        };
      };
    };

    # -- Indent-blankline: indentation guides --
    visuals.indent-blankline = {
      enable = true;
      setupOpts = {};
    };

    # -- Lualine: status line --
    statusline.lualine = {
      enable = true;

      componentSeparator = {
        left = "";
        right = "";
      };
      sectionSeparator = {
        left = "";
        right = "";
      };

      activeSection = {
        a = ["'mode'"];
        b = [
          "'branch'"
          "'diff'"
          ''{ "diagnostics", sources = { "nvim_diagnostic" }, symbols = { error = " ", warn = " ", info = " ", hint = " " } }''
        ];
        c = ["'filename'"];
        x = ["'copilot'" "'encoding'" "'fileformat'" "'filetype'"];
        y = ["'progress'"];
        z = ["'location'"];
      };

      inactiveSection = {
        a = [];
        b = [];
        c = ["'filename'"];
        x = ["'location'"];
        y = [];
        z = [];
      };
    };

    # -- Symbol-usage: show references/definitions above symbols --
    extraPlugins = {
      symbol-usage-nvim = {
        package = pkgs.vimPlugins.symbol-usage-nvim;
        setup = ''
          require('symbol-usage').setup {
            vt_position = 'above',
          }
        '';
      };
    };

    # Oil keymaps
    keymaps = [
      {
        key = "-";
        mode = "n";
        action = "<CMD>Oil<CR>";
        desc = "Open parent directory";
      }
      {
        key = "<leader>-";
        mode = "n";
        action = "require('oil').toggle_float";
        lua = true;
        desc = "Open Oil float";
      }
    ];
  };
}

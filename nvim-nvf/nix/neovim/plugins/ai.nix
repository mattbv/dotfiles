# GitHub Copilot with privacy controls
# Translated from nvim/lua/config/plugins/ai.lua
#
# copilot-lualine (status in lualine x section) is handled here.
# The privacy guard (disable Copilot for ~/code/_private/) requires raw Lua.
{pkgs, lib, ...}: {
  config.vim = {
    # Copilot via NVF's built-in assistant module
    assistant.copilot = {
      enable = true;
      cmp.enable = true; # copilot-cmp bridge for nvim-cmp source

      # Disable default suggestion mappings -- Tab is handled by our smart Tab chain
      mappings = {
        panel = {
          accept = "<CR>";
          jumpNext = "]]";
          jumpPrev = "[[";
          open = "<M-CR>";
          refresh = "gr";
        };
        suggestion = {
          accept = null; # Handled by smart Tab in autocomplete.nix
          acceptLine = null;
          acceptWord = null;
          dismiss = "<C-]>";
          next = "<M-]>";
          prev = "<M-[>";
        };
      };

      setupOpts = {
        panel = {
          enabled = true;
          auto_refresh = true;
          layout = {
            position = "bottom";
            ratio = 0.4;
          };
        };
        suggestion = {
          enabled = true;
          auto_trigger = true;
          accept = false; # Disable built-in accept keymapping
        };
        copilot_model = "gpt-41-copilot";
      };
    };

    # copilot-lualine for status in statusline
    extraPlugins = {
      copilot-lualine = {
        package = pkgs.vimPlugins.copilot-lualine;
        setup = ""; # No setup needed, just needs to be loaded
      };
    };

    # Privacy guard: disable Copilot for projects under ~/code/_private/
    # Also hides copilot suggestions when cmp menu is open
    luaConfigRC.copilot-privacy = ''
      -- Hide copilot suggestions when cmp menu is open
      local cmp_ok, cmp = pcall(require, 'cmp')
      if cmp_ok then
        cmp.event:on('menu_opened', function()
          vim.b.copilot_suggestion_hidden = true
        end)
        cmp.event:on('menu_closed', function()
          vim.b.copilot_suggestion_hidden = false
        end)
      end

      -- Disable copilot for private projects
      local home_dir = os.getenv 'HOME' or os.getenv 'USERPROFILE'
      if home_dir then
        local private_path = home_dir .. '/code/_private'
        local current_dir = vim.fn.getcwd()
        if string.find(current_dir, private_path) == 1 then
          vim.cmd 'Copilot disable'
        end
      end
    '';
  };
}

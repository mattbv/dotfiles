# Autocommands and autogroups translated from nvim/init.lua
{lib, ...}: {
  config.vim = {
    augroups = [
      {
        name = "YankHighlight";
        clear = true;
      }
    ];

    autocmds = [
      {
        event = ["TextYankPost"];
        pattern = ["*"];
        group = "YankHighlight";
        desc = "Highlight on yank";
        callback = lib.generators.mkLuaInline ''
          function()
            vim.highlight.on_yank()
          end
        '';
      }
    ];
  };
}

# Vim options and globals translated from nvim/init.lua
{pkgs, ...}: {
  config.vim = {
    # -- Globals --
    globals = {
      mapleader = " ";
      maplocalleader = "\\";
    };

    # -- Extra packages available in neovim's PATH --
    extraPackages = with pkgs; [
      nodejs # Required by copilot.lua
      fd # Optional: faster file finding for telescope
      xclip # Clipboard support (X11)
      wl-clipboard # Clipboard support (Wayland/GNOME)
    ];

    # -- Basic settings --
    # NVF convenience options that map to common vim.o.* settings
    hideSearchHighlight = true;
    lineNumberMode = "relNumber";
    searchCase = "smart";

    # -- vim.o.* options --
    # Freeform attribute set: each key maps directly to vim.o.<key>
    options = {
      shiftwidth = 4;
      mouse = "a";
      clipboard = "unnamedplus";
      breakindent = true;
      undofile = true;
      signcolumn = "yes";
      updatetime = 250;
      tm = 300; # timeoutlen -- NVF uses vim.o.tm which Vim resolves to timeoutlen
      completeopt = "menuone,noselect";
      termguicolors = true;
    };
  };
}

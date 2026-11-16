# Treesitter configuration
# Translated from nvim/lua/config/plugins/treesitter.lua
#
# NVF language modules automatically enable treesitter grammars for their
# respective languages when enableTreesitter = true (set in languages.nix).
# This file adds extra grammars not covered by language modules.
{pkgs, ...}: {
  config.vim.treesitter = {
    enable = true;

    # Highlight is the core feature we need
    highlight.enable = true;

    # Context (treesitter-context) is enabled in coding.nix

    # Extra grammars not covered by language modules
    # Language modules auto-include: c, cpp, go, lua, python, rust,
    # javascript, typescript, tsx, bash, markdown, markdown_inline, yaml, nix
    # We need to add: json, vimdoc, vim, dot
    grammars = with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
      json
      vimdoc
      vim
      # NOTE: dot grammar may not be available in nixpkgs treesitter grammars.
      # If the build fails, remove this line.
      dot
    ];
  };
}

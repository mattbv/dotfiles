{
  imports = [
    # Phase 1: Foundation
    ./options.nix
    ./autocmds.nix
    ./keymaps.nix

    # Phase 2: Language support + LSP
    ./languages.nix
    ./lsp.nix
    ./plugins/autoformat.nix

    # Phase 3: Treesitter
    ./plugins/treesitter.nix

    # Phase 4: Core plugins
    ./plugins/theme.nix
    ./plugins/telescope.nix
    ./plugins/git.nix
    ./plugins/mini.nix
    ./plugins/utils.nix
    ./plugins/ui.nix
    ./plugins/dashboard.nix
    ./plugins/coding.nix

    # Phase 5: Completion + AI
    ./plugins/autocomplete.nix
    ./plugins/ai.nix
  ];
}

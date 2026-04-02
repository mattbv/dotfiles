# dotfiles

Personal configuration files for NixOS and development tools.

## Structure

```
ghostty/          # Ghostty terminal configuration
nixos/            # NixOS system configuration
  configuration.nix   # Main NixOS config (deployed to /etc/nixos/)
  system-flake.nix    # System flake (deployed to /etc/nixos/flake.nix)
nvim-nvf/         # Neovim config via NVF (Nix Vim Framework) standalone flake
  flake.nix           # Neovim-only flake
  nix/neovim/         # NVF module definitions
nvim-legacy/      # Previous Lua-based Neovim config (lazy.nvim + Mason)
```

## Deployment (NixOS)

1. Copy NVF flake to the NixOS machine:
   ```bash
   # rsync or copy nvim-nvf/ to /home/matheus/nvim_nixos/ on the NixOS host
   ```

2. Copy NixOS configs:
   ```bash
   sudo cp nixos/configuration.nix /etc/nixos/configuration.nix
   sudo cp nixos/system-flake.nix /etc/nixos/flake.nix
   ```

3. Rebuild:
   ```bash
   sudo nix flake update neovim --flake /etc/nixos
   sudo nixos-rebuild switch --flake /etc/nixos#nixos
   ```

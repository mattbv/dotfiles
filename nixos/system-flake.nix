# Copy this file to /etc/nixos/flake.nix
# Then rebuild with: sudo nixos-rebuild switch --flake /etc/nixos#nixos
{
  description = "NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    neovim.url = "path:/home/matheus/nvim_nixos";
  };

  outputs = {
    nixpkgs,
    neovim,
    ...
  }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ({pkgs, ...}: {
          environment.systemPackages = [
            neovim.packages.${pkgs.stdenv.system}.default
          ];
        })
      ];
    };
  };
}

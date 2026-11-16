{
  description = "Neovim configuration powered by NVF";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nvf = {
      url = "github:NotAShelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    nvf,
    ...
  }: let
    systems = ["x86_64-linux" "aarch64-darwin"];
    forEachSystem = f:
      nixpkgs.lib.genAttrs systems (system:
        f {
          pkgs = nixpkgs.legacyPackages.${system};
          inherit system;
        });
  in {
    # Standalone neovim package (nix build .# or nix run .#)
    packages = forEachSystem ({pkgs, ...}: {
      default =
        (nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = [
            ./nix/neovim
          ];
        })
        .neovim;
    });
  };
}

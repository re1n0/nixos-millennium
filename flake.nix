{
  description = "Declarative configuration of Millennium Steam for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    millennium.url = "github:SteamClientHomebrew/Millennium/next?dir=packages/nix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./home-modules
        ./modules
        ./pkgs
      ];
    };
}

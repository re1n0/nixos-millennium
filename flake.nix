{
  description = "Declarative configuration of Millennium Steam for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    systems.url = "github:nix-systems/default";

    flake-parts.url = "github:hercules-ci/flake-parts";

    millennium = {
      url = "github:SteamClientHomebrew/Millennium/next?dir=packages/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = import inputs.systems;

      imports = [
        ./home-modules
        ./modules
        ./pkgs
      ];

      perSystem = {pkgs, ...}: {
        formatter = pkgs.treefmt.withConfig {
          runtimeInputs = [pkgs.alejandra];
          settings = {
            on-unmatched = "info";
            formatter.alejandra = {
              command = "alejandra";
              includes = ["*.nix"];
            };
          };
        };
      };
    };
}

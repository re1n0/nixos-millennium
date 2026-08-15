_: {
  flake.homeManagerModules.default = {
    imports = [
      ./steam.nix
    ];

    home-manager.useGlobalPkgs = true;
  };

  flake.homeManagerModules.stylix = {
    imports = [
      ./stylix.nix
    ];
  };
}

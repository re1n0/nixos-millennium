_: {
  flake.homeManagerModules.default = {
    imports = [
      ./steam.nix
    ];
  };

  flake.homeManagerModules.stylix = {
    imports = [
      ./stylix.nix
    ];
  };
}

{ self, ... }: {
  flake.homeManagerModules.default = {
    imports = [
      ./steam.nix
    ];

    nixpkgs.overlays = [
      self.overlays.default
    ];
  };

  flake.homeManagerModules.stylix = {
    imports = [
      ./stylix.nix
    ];
  };
}

{
  self,
  lib,
  ...
}:
{
  flake.homeManagerModules.default = { osConfig, ... }: {
    imports = [
      ./steam.nix
    ];

    nixpkgs.overlays = lib.mkIf (!(osConfig.home-manager.useGlobalPkgs or false)) [
      self.overlays.default
    ];
  };

  flake.homeManagerModules.stylix = {
    imports = [
      ./stylix.nix
    ];
  };
}

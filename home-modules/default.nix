_: {
  flake.homeManagerModules.default = {
    imports = [
      ./steam.nix
    ];
  };
}

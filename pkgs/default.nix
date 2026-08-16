{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  perSystem = {
    system,
    pkgs,
    config,
    ...
  }: let
    millenniumThemes = pkgs.callPackage ./millennium-themes {};
    millenniumPlugins = pkgs.callPackage ./millennium-plugins {};

    standalonePackages =
      {
        close-steam-session = pkgs.callPackage ./close-steam-session {};
      }
      // (inputs.millennium.packages.${system} or {});
  in {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    legacyPackages =
      standalonePackages
      // {
        inherit millenniumThemes millenniumPlugins;
      };

    packages = removeAttrs (standalonePackages // millenniumThemes // millenniumPlugins) [
      "override"
      "overrideDerivation"
    ];

    overlayAttrs = config.legacyPackages;
  };
}

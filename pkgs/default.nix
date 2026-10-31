{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  perSystem = {
    system,
    pkgs,
    final,
    config,
    ...
  }: let
    millenniumThemes = final.callPackage ./millennium-themes {};
    millenniumPlugins = final.callPackage ./millennium-plugins {};

    standalonePackages =
      {
        close-steam-session = pkgs.callPackage ./close-steam-session {};
        starlight = pkgs.callPackage ./starlight {};
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

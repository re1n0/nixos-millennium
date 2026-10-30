{inputs, ...}: {
  imports = [
    inputs.flake-parts.flakeModules.easyOverlay
  ];

  perSystem = {
    system,
    final,
    config,
    ...
  }: let
    millenniumThemes = final.callPackage ./millennium-themes {};
    millenniumPlugins = final.callPackage ./millennium-plugins {};

    standalonePackages =
      {
        close-steam-session = final.callPackage ./close-steam-session {};
        starlight = final.callPackage ./starlight {};
      }
      // (inputs.millennium.packages.${system} or {});
  in {
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

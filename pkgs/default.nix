{
  inputs,
  ...
}:
let
  pins = import ../npins;
in
{
  systems = [ "x86_64-linux" ];

  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

  perSystem =
    {
      system,
      pkgs,
      config,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          inputs.millennium.overlays.default
        ];
      };

      overlayAttrs = config.packages // config.legacyPackages;

      legacyPackages = {
        millenniumThemes = pkgs.callPackage ./millennium-themes { inherit pins; };
        millenniumPlugins = pkgs.callPackage ./millennium-plugins { inherit pins; };
      };

      packages = {
        close-steam-session = pkgs.callPackage ./close-steam-session { };
      }
      // (inputs.millennium.packages.${system} or { });
    };
}

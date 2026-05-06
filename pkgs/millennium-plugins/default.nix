{
  inputs,
  pins,
  pkgs,
}:
let
  mkPlugin =
    name: source:
    inputs.dream2nix.lib.evalModules {
      packageSets.nixpkgs = pkgs;
      specialArgs = {
        inherit source;
      };
      modules = [
        ./${name}
        {
          paths.projectRoot = ../../.;
          paths.projectRootFile = ".git";
          paths.package = ../../pkgs/millennium-plugins/${name};
        }
      ];
    };

  inherit (pins)
    Extendium
    ;
in
{
  extendium = mkPlugin "extendium" Extendium;
}

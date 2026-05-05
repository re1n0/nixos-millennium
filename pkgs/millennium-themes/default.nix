{ callPackage }:
{
  adwaita = callPackage ./adwaita.nix { };
  atoms = callPackage ./atoms.nix { };
  material-theme = callPackage ./material-theme.nix { };
  metro = callPackage ./metro.nix { };
  minimal-dark = callPackage ./minimal-dark.nix { };
  space = callPackage ./space.nix { };
}

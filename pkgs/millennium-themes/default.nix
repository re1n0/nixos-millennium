{
  stdenvNoCC,
  pins,
}:
let
  mkTheme =
    pname: version: src:
    stdenvNoCC.mkDerivation {
      inherit pname version src;
      installPhase = ''
        mkdir -p $out
        cp -r ./* $out/
      '';
    };

  inherit (pins)
    Adwaita
    Material-Theme
    MetroSteam
    Minimal-Dark
    SpaceTheme
    ;
in
{
  adwaita = mkTheme "adwaita" Adwaita.version Adwaita;
  material-theme = mkTheme "material-theme" "0-git+${Material-Theme.revision}" Material-Theme;
  metro = mkTheme "metro" "0-git+${MetroSteam.revision}" MetroSteam;
  minimal-dark = mkTheme "minimal-dark" Minimal-Dark.version Minimal-Dark;
  space = mkTheme "space" "0-git+${SpaceTheme.revision}" SpaceTheme;
}

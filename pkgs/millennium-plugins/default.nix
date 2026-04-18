{
  stdenvNoCC,
  pins,
}:
let
  mkPlugin =
    pname: version: src:
    stdenvNoCC.mkDerivation {
      inherit pname version src;

      installPhase = ''
        mkdir -p $out
        cp -r ./* $out/
      '';
    };

  inherit (pins)
    Extendium
    ;
in
{
  extendium = mkPlugin "extendium" Extendium.version Extendium;
}

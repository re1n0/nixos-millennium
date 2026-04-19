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
    HLTB
    ;
in
{
  extendium = mkPlugin "extendium" Extendium.version Extendium;
  hltb = mkPlugin "hltb-for-millennium" HLTB.version HLTB;
}

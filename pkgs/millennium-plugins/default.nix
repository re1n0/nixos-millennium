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
    non-steam-playtimes
    ;
in
{
  extendium = mkPlugin "extendium" Extendium.version Extendium;
  hltb = mkPlugin "hltb-for-millennium" HLTB.version HLTB;
  non-steam-playtimes =
    mkPlugin "non-steam-playtimes" "0-git+${non-steam-playtimes.revision}"
      non-steam-playtimes;
}

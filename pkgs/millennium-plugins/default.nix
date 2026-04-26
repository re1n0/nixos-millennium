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
    Gratitude
    HLTB
    non-steam-playtimes
    browser-history
    ;
in
{
  extendium = mkPlugin "extendium" Extendium.version Extendium;
  gratitude = mkPlugin "gratitude" Gratitude.version Gratitude;
  hltb = mkPlugin "hltb-for-millennium" HLTB.version HLTB;
  non-steam-playtimes =
    mkPlugin "non-steam-playtimes" "0-git+${non-steam-playtimes.revision}"
      non-steam-playtimes;
  browser-history = mkPlugin "browser-history" "0-git+${browser-history.revision}" browser-history;
}

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "hltb";

  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jcdoll";
    repo = "hltb-millennium-plugin";
    rev = "v${finalAttrs.version}";
    hash = "sha256-q6hCSkviga/KuGOSlLuZP/QNLobi7bao3VuJJU/Tiss=";
  };

  npmDepsHash = "sha256-0Ak8FWwGPUvUYHmWA5w/quHBCF4DBM8o9Sn5ltlbJL4=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/.millennium/

    cp -r .millennium/Dist $out
    cp -r backend $out
    cp plugin.json $out
    cp LICENSE $out
    cp README.md $out

    runHook postInstall
  '';

  meta = {
    description = "HLTB for Steam Homebrew (Millennium)";
    homepage = "https://github.com/jcdoll/hltb-millennium-plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rein ];
    platforms = [ "x86_64-linux" ];
  };
})

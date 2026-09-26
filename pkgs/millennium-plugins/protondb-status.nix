{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "protondb-status";

  version = "1.0.0-unstable-2026-09-21";

  src = fetchFromGitHub {
    owner = "nyakuoff";
    repo = "protondb-badge";
    rev = "b8c8b430d1df1ca90285af354d369b5cdb45131c";
    hash = "sha256-6x4xFk2jm71D+5bYvxt2mEctbdl3jmDYJKK58Natgbc=";
  };

  npmDepsHash = "sha256-U4RmuxSBNmk8O7AJFZyuyXWj2urnN8Az4vdZVWl8iGU=";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/.millennium/

    cp -r .millennium/Dist $out/.millennium
    cp -r backend $out
    cp plugin.json $out
    cp README.md $out

    runHook postInstall
  '';

  meta = {
    description = "A Millennium plugin that shows ProtonDB compatibility rating in the game details row";
    homepage = "https://github.com/nyakuoff/protondb-badge";
    maintainers = with lib.maintainers; [rein];
    platforms = ["x86_64-linux"];
  };
})

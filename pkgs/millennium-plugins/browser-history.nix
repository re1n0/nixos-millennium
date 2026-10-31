{
  lib,
  fetchFromGitHub,
  starlight,
  bun,
  fetchBunDeps,
  nodejs,
}: let
  version = "0-unstable-2026-09-29";

  src = fetchFromGitHub {
    owner = "ricewind012";
    repo = "steam-browser-history";
    rev = "ae778d40aa02424418688c859fe2a3cf6b32f1d8";
    hash = "sha256-jZAOiF50rW6ZdF/MWFMCSONeJNB3lTbsPw3ABV403lk=";
  };

  node_modules = fetchBunDeps {
    pname = "browse-history-bun-deps";
    inherit version src;
    hash = "sha256-bovR/9UJrKM97WmQJgvdeHYdOv63e9yTR5wN91QSXv0=";
  };
in
  starlight.buildStarlightPlugin {
    pname = "browser-history";
    inherit version src;

    nativeBuildInputs = [
      bun
      nodejs
    ];

    buildPhase = ''
      runHook preBuild

      cp -r ${node_modules}/node_modules .

      mkdir build
      starlight pack --release -o build

      runHook postBuild
    '';

    passthru.node_modules = node_modules;

    meta = {
      description = "A Millennium plugin to see your browser history on URL bar click";
      homepage = "https://github.com/ricewind012/steam-browser-history";
      maintainers = with lib.maintainers; [rein];
    };
  }

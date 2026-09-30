{
  lib,
  stdenv,
  fetchBunDeps,
  bun,
  nodejs,
  fetchFromGitHub,
  autoPatchelfHook,
}: let
  version = "0-unstable-2026-09-29";

  src = fetchFromGitHub {
    owner = "ricewind012";
    repo = "steam-browser-history";
    rev = "ae778d40aa02424418688c859fe2a3cf6b32f1d8";
    hash = "sha256-jZAOiF50rW6ZdF/MWFMCSONeJNB3lTbsPw3ABV403lk=";
  };

  node_modules = fetchBunDeps {
    pname = "browser_history-bun-deps";
    inherit version src;
    hash = "sha256-bovR/9UJrKM97WmQJgvdeHYdOv63e9yTR5wN91QSXv0=";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "browser_history";
    inherit version src;

    nativeBuildInputs = [
      bun
      nodejs
      autoPatchelfHook
    ];

    buildInputs = [stdenv.cc.cc.lib];

    buildPhase = ''
      runHook preBuild

      diff -q ./bun.lock ${node_modules}/bun.lock || {
        echo "bun.lock mismatch"
        exit 1
      }

      cp -r ${node_modules}/node_modules .
      chmod -R u+w node_modules
      patchShebangs node_modules
      autoPatchelf node_modules

      export HOME=$TMPDIR
      export XDG_DATA_HOME=$TMPDIR/xdg-data
      bun run starlight lsp
      bun run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out

      cp $XDG_DATA_HOME/millennium/plugins/${finalAttrs.passthru.starFile} $out

      runHook postInstall
    '';

    passthru.node_modules = node_modules;
    passthru.starFile = "steam-browser-history.star";

    meta = {
      description = "A Millennium plugin to see your browser history on URL bar click";
      homepage = "https://github.com/ricewind012/steam-browser-history";
      maintainers = with lib.maintainers; [rein];
      platforms = ["x86_64-linux"];
    };
  })

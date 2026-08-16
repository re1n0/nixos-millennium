{
  lib,
  stdenv,
  fetchBunDeps,
  bun,
  nodejs,
  fetchFromGitHub,
}: let
  version = "0-unstable-2026-07-08";

  src = fetchFromGitHub {
    owner = "ricewind012";
    repo = "steam-browser-history";
    rev = "e31967d7c8462e81af68c414b038a0ce0a3c7e58";
    hash = "sha256-GfYApyLvdcvdTNdrwuMWofdoWIfuDOnJvvVHeaEOhus=";
  };

  node_modules = fetchBunDeps {
    pname = "extendium-bun-deps";
    inherit version src;
    hash = "sha256-r+2gbkZrp9S0KqCmSdqkRfTFUiOfQOV6fSvxAcWoX1I=";
  };
in
  stdenv.mkDerivation {
    pname = "browser_history";
    inherit version src;

    nativeBuildInputs = [
      bun
      nodejs
    ];

    buildPhase = ''
      runHook preBuild

      diff -q ./bun.lock ${node_modules}/bun.lock || {
        echo "bun.lock mismatch"
        exit 1
      }

      cp -r ${node_modules}/node_modules .
      chmod -R u+w node_modules
      patchShebangs node_modules

      export HOME=$TMPDIR
      bun run build

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out/.millennium/

      cp -r .millennium/Dist $out/.millennium
      cp plugin.json $out
      cp README.md $out

      runHook postInstall
    '';

    passthru.node_modules = node_modules;

    meta = {
      description = "A Millennium plugin to see your browser history on URL bar click";
      homepage = "https://github.com/ricewind012/steam-browser-history";
      maintainers = with lib.maintainers; [rein];
      platforms = ["x86_64-linux"];
    };
  }

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
    owner = "luthor112";
    repo = "steam-collections-plus";
    rev = "main";
    hash = "sha256-GfYApyLvdcvdTNdrwuMWofdoWIfuDOnJvvVHeaEOhus=";
  };

  node_modules = fetchBunDeps {
    pname = "collections-plus-bun-deps";
    inherit version src;
    hash = "sha256-r+2gbkZrp9S0KqCmSdqkRfTFUiOfQOV6fSvxAcWoX1I=";
  };
in
  stdenv.mkDerivation {
    pname = "collections_plus";
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
      description = "A Millennium plugin that adds extra functionality to collections on Steam";
      homepage = "https://github.com/luthor112/steam-collections-plus";
      maintainers = with lib.maintainers; [ruby_rose];
      platforms = ["x86_64-linux"];
    };
  }


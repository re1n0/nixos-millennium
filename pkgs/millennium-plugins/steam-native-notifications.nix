{
  lib,
  stdenv,
  fetchBunDeps,
  bun,
  nodejs,
  fetchFromGitHub,
  autoPatchelfHook,
}: let
  version = "latest-unstable-2026-09-11";

  src = fetchFromGitHub {
    owner = "tyvsmith";
    repo = "steam-native-notifications";
    rev = "1ad10344ff163521b2190107fdda0c9199f2ffd1";
    hash = "sha256-Tl4WdROZrYzISA39kvbkNEOdtsLjTRGGF1NjdYxQAZ8=";
  };

  node_modules = fetchBunDeps {
    pname = "steam-native-notifications-bun-deps";
    inherit version src;
    hash = "sha256-HRNWqg47uLyLPBTVQxe1F3dgwq7e45iKXPrbfxLDd/Q=";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "steam-native-notifications";
    inherit version src;

    nativeBuildInputs = [bun nodejs autoPatchelfHook];

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
      bun run prepare
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
    passthru.starFile = "me.tysmith.steam-native-notifications.star";

    meta = {
      description = "Native notifications for Steam on Linux";
      homepage = "https://github.com/tyvsmith/steam-native-notify";
      maintainers = with lib.maintainers; [rein];
      license = lib.licenses.mit;
      platforms = ["x86_64-linux"];
    };
  })

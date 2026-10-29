{
  lib,
  stdenv,
  fetchBunDeps,
  bun,
  nodejs,
  fetchFromGitHub,
  autoPatchelfHook,
}: let
  version = "latest-unstable-2026-10-29";

  src = fetchFromGitHub {
    owner = "tyvsmith";
    repo = "steam-native-notifications";
    rev = "c65309efa2481494842445ab40c17d9a9b143225";
    hash = "sha256-xGhyuKHPYfnv9NlPupO0ySlpL5Dob3WAo5WzZVo446Q=";
  };

  node_modules = fetchBunDeps {
    pname = "steam-native-notifications-bun-deps";
    inherit version src;
    hash = "sha256-n2W6K8tqUPoJ+2yA/QrVVOtR1VoNrAbSnNCJHVMpWPU=";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "steam-native-notifications";
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

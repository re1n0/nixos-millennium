{
  lib,
  stdenv,
  fetchBunDeps,
  bun,
  nodejs,
  fetchFromGitHub,
  autoPatchelfHook,
}: let
  version = "latest-unstable-2026-10-25";

  src = fetchFromGitHub {
    owner = "tyvsmith";
    repo = "steam-native-notifications";
    rev = "6b6d424afea6206524a2aaba0245551102dee960";
    hash = "sha256-cj0nypmDiY5YDV9pXvwnceVKZfmzSclIuLp5iECejfA=";
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

{
  lib,
  fetchFromGitHub,
  starlight,
  bun,
  fetchBunDeps,
  nodejs,
}: let
  version = "latest-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "tyvsmith";
    repo = "steam-native-notifications";
    rev = "209a0b05752ccc4346ff1f4b23e558309739231b";
    hash = "sha256-nRZ1y3SG2EJ4tPCiNYSapUZ82NhGD6q2WA6wR0VuSek=";
  };

  node_modules = fetchBunDeps {
    pname = "steam-native-notifications-bun-deps";
    inherit version src;
    hash = "sha256-n2W6K8tqUPoJ+2yA/QrVVOtR1VoNrAbSnNCJHVMpWPU=";
  };
in
  starlight.buildStarlightPlugin {
    pname = "steam-native-notifications";
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
      description = "Native notifications for Steam on Linux";
      homepage = "https://github.com/tyvsmith/steam-native-notifications";
      maintainers = with lib.maintainers; [rein];
      license = lib.licenses.mit;
    };
  }

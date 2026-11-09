{
  lib,
  fetchFromGitHub,
  starlight,
  bun,
  fetchBunDeps,
  nodejs,
}: let
  version = "latest-unstable-2026-11-09";

  src = fetchFromGitHub {
    owner = "tyvsmith";
    repo = "steam-native-notifications";
    rev = "4d68447faca677cd6f0645133349963c07d047e7";
    hash = "sha256-kTQItbV00kxDo6Ul02RDYjw+g1bxJf8bmJLMoQloVkQ=";
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

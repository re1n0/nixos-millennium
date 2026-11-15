{
  lib,
  fetchFromGitHub,
  starlight,
  bun,
  fetchBunDeps,
  nodejs,
}: let
  version = "latest-unstable-2026-11-14";

  src = fetchFromGitHub {
    owner = "tyvsmith";
    repo = "steam-native-notifications";
    rev = "a7e0d74e7a989fac792e1fb5c3ad7a535face275";
    hash = "sha256-TFnIRoLQb+aTKfd4aYDWS7f9yRTK5BHkzAE9TYo8v3s=";
  };

  node_modules = fetchBunDeps {
    pname = "steam-native-notifications-bun-deps";
    inherit version src;
    hash = "sha256-LoD+gXLuF4yj3CRcf+o/zFAbWhgx/6ydsfab9ecWFF8=";
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

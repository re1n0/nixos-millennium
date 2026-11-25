{
  lib,
  fetchFromGitHub,
  starlight,
  bun,
  fetchBunDeps,
  nodejs,
}: let
  version = "latest-unstable-2026-11-25";

  src = fetchFromGitHub {
    owner = "tyvsmith";
    repo = "steam-native-notifications";
    rev = "baf3a6a743c2c61d65ab0c1701b12f766cb3fe0b";
    hash = "sha256-wfX5ByDsGkg1KWxvACgz3wWEs10BHJ7JQqcsh1icFa0=";
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

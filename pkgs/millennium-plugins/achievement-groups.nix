{
  lib,
  stdenv,
  fetchBunDeps,
  bun,
  nodejs,
  fetchFromGitHub,
}: let
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "BossSloth";
    repo = "SteamHunter-plugin";
    rev = "v${version}";
    hash = "sha256-Cg1IIWSm4GW8YETn6YtNJ9tvV4W4hlH1sjw0QdeZ/h0=";
  };

  node_modules = fetchBunDeps {
    pname = "achievement-groups-bun-deps";
    inherit version src;
    hash = "sha256-H+XzbSy//dlSeB7Pke4Zr7kyiNUFgSHMCPVlkFwAQJw=";
  };
in
  stdenv.mkDerivation {
    pname = "achievement-groups";
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

      tar --exclude='*.scss' -C .millennium -cf - . | tar -C "$out/.millennium" -xf -
      cp -r backend $out
      cp plugin.json $out
      cp LICENSE $out
      cp README.md $out
      cp CHANGELOG.md $out

      runHook postInstall
    '';

    passthru.node_modules = node_modules;

    meta = {
      description = "A Millennium plugin for the steam client that adds achievement groups and point just like the SteamHunters website";
      homepage = "https://github.com/BossSloth/SteamHunter-plugin";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [rein];
      platforms = ["x86_64-linux"];
    };
  }

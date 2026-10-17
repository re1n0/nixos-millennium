{
  lib,
  stdenv,
  fetchBunDeps,
  bun,
  nodejs,
  fetchFromGitHub,
}: let
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "BossSloth";
    repo = "SteamHunter-plugin";
    rev = "v${version}";
    hash = "sha256-45P4En9PAxeJ9RGWlljuPvzPIjvYg8aOnIcXjs0PM/s=";
  };

  node_modules = fetchBunDeps {
    pname = "achievement-groups-bun-deps";
    inherit version src;
    hash = "sha256-oPEYcIjFIQgu3IB7Jol/Zbr0vc9i6WgrzJukGhEalIY=";
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

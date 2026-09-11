{
  lib,
  stdenv,
  fetchBunDeps,
  bun,
  nodejs,
  fetchFromGitHub,
}: let
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "luthor112";
    repo = "steam-easygrid";
    rev = "main";
    hash = "sha256-WoQf/GJnrcKkTeyga2PqzvaiaLgsYpdFbdEj+CaEqXo=";
  };

  node_modules = fetchBunDeps {
    pname = "easygrid-bun-deps";
    inherit version src;
    hash = "sha256-aByhqc5tBKa//j8L0xSHAicLl6u3C+zPb7eijNvwKns=";
  };
in
  stdenv.mkDerivation {
    pname = "easygrid";
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
      cp -r fake-header-extension $out
      cp -r backend $out
      cp plugin.json $out
      cp LICENSE $out
      cp README.md $out
      cp CHANGELOG.md $out

      runHook postInstall
    '';

    passthru.node_modules = node_modules;

    meta = {
      description = "A Millennium plugin that adds quick and easy SteamGridDB integration to Steam.";
      homepage = "https://github.com/luthor112/steam-easygrid";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ruby_rose];
      platforms = ["x86_64-linux"];
    };
  }


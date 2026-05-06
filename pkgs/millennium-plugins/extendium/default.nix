{
  lib,
  config,
  dream2nix,
  source,
  ...
}:
{
  imports = [
    dream2nix.modules.dream2nix.nodejs-package-json-v3
    dream2nix.modules.dream2nix.nodejs-granular-v3
  ];

  deps =
    { nixpkgs, ... }:
    {
      inherit (nixpkgs)
        stdenv
        bun
        ;
      npm = nixpkgs.nodejs;
    };

  name = lib.mkForce "extendium";
  version = lib.mkForce source.version;

  nodejs-package-lock-v3.packageLock = lib.mkForce (
    let
      raw = lib.importJSON ./lock.json;
    in
    raw
    // {
      packages = lib.filterAttrs (_path: pkg: pkg ? resolved) raw.package-lock.packages;
    }
  );

  nodejs-granular-v3 = {
    runBuild = true;
    buildScript = ''
      bun run build
    '';
  };

  mkDerivation = {
    src = lib.cleanSource source;

    nativeBuildInputs = with config.deps; [
      bun
    ];

    installPhase = ''
      mkdir -p $out/.millennium/

      tar --exclude='*.scss' -C .millennium/Dist -cf - . | tar -C "$out/.millennium" -xf -
      cp -r backend $out
      cp LICENSE $out
      cp README.md $out
      cp plugin.json $out
      cp metadata.json $out
      cp CHANGELOG.md $out
      cp -r fake-header-extension $out
    '';

    meta = {
      description = "A Millennium plugin for the steam client that adds chrome extension support";
      homepage = "https://github.com/BossSloth/Extendium";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ rein ];
    };
  };
}

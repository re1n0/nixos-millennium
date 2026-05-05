{
  lib,
  stdenv,
  fetchBunDeps,
  bun,
  nodejs,
  fetchFromGitHub,
}:
let
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "BossSloth";
    repo = "Extendium";
    rev = "v${version}";
    hash = "sha256-pseB3xD30abv9w0iukRJU653WL1kzzjli/jJmNCHG3s=";
  };

  node_modules = fetchBunDeps {
    pname = "extendium-bun-deps";
    inherit version src;
    hash = "sha256-aByhqc5tBKa//j8L0xSHAicLl6u3C+zPb7eijNvwKns=";
  };
in
stdenv.mkDerivation {
  pname = "extendium";
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

    tar --exclude='*.scss' -C .millennium/Dist -cf - . | tar -C "$out/.millennium" -xf -
    cp -r fake-header-extension $out
    cp -r backend $out
    cp plugin.json $out
    cp LICENSE $out
    cp README.md $out
    cp CHANGELOG.md $out

    runHook postInstall
  '';

  # passthru.updateScript = ./update.sh;

  meta = {
    description = "A Millennium plugin for the Steam client that adds Chrome extension support";
    homepage = "https://github.com/BossSloth/Extendium";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rein ];
    platforms = [ "x86_64-linux" ];
  };
}

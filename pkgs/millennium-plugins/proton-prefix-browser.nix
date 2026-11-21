{
  lib,
  stdenv,
  fetchBunDeps,
  bun,
  nodejs,
  fetchFromGitHub,
}: let
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "EvilNick2";
    repo = "proton-prefix-browser";
    tag = "v${version}";
    hash = "sha256-KsBKjcHxh3RxRH9I4x4xwDIMYhwMDYEC9tqpU2Xqwjk=";
  };

  node_modules = fetchBunDeps {
    pname = "proton-prefix-browser-bun-deps";
    inherit version src;
    hash = "sha256-/1aocNX0V6t3VMQyQJ3+Juf5i+KMUe0h+MuOuCqTSRM=";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "proton-prefix-browser";
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
      description = "";
      homepage = "https://github.com/EvilNick2/proton-prefix-browser";
      changelog = "https://github.com/EvilNick2/proton-prefix-browser/blob/${finalAttrs.src.rev}/CHANGELOG.md";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [rein];
    };
  })

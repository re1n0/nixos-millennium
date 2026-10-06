{
  lib,
  stdenv,
  fetchBunDeps,
  bun,
  nodejs,
  fetchFromGitHub,
}: let
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "Alex979";
    repo = "Steam-Recent-Chats-plugin";
    rev = "v${version}";
    hash = "sha256-rZkXxq4iTrdCN8Rw6V6zk5PX8/3YOuuJTOq/myBb3gI=";
  };

  node_modules = fetchBunDeps {
    pname = "recent-chats-bun-deps";
    inherit version src;
    hash = "sha256-bEFQaMHGk5pBxGKdLps10gpAFhXfsyTQgT33EyJyrOw=";
  };
in
  stdenv.mkDerivation {
    pname = "recent-chats";
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
      cp plugin.json $out
      cp LICENSE $out
      cp README.md $out

      runHook postInstall
    '';

    passthru.node_modules = node_modules;

    meta = {
      description = "A Millennium Plugin that adds a Chats tab to Steam's desktop Friends window, for easy access to recent chats and game invites.";
      homepage = "https://github.com/Alex979/Steam-Recent-Chats-plugin";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [rein];
      platforms = ["x86_64-linux"];
    };
  }

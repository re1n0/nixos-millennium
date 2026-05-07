{
  lib,
  stdenv,
  fetchBunDeps,
  bun,
  nodejs,
  fetchFromGitHub,
}:
let
  version = "0-unstable-2026-03-15";

  src = fetchFromGitHub {
    owner = "k0d13";
    repo = "steam-non-steam-playtimes";
    rev = "3d276fba62ec4920e03b344eb045e4b186944e54";
    hash = "sha256-XAcN0IaeBbjaIoJKO0in8MN81+zTXpCUhjEsky8pzXg=";
  };

  node_modules = fetchBunDeps {
    pname = "non-steam-playtimes-bun-deps";
    inherit version src;
    hash = "sha256-Kkaqk6n95rXmqRDNJXRdUOYYUh5Yn3aR9qSJATutRfM=";
  };
in
stdenv.mkDerivation {
  pname = "non-steam-playtimes";
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

    cp -r .millennium/Dist $out/.millennium
    cp -r backend $out
    cp plugin.json $out
    cp README.md $out

    runHook postInstall
  '';

  passthru.updateScript = ./update-bun.sh;

  meta = {
    description = "A Millennium plugin for tracking playtime of non-Steam apps ";
    homepage = "https://github.com/k0d13/steam-non-steam-playtimes";
    maintainers = with lib.maintainers; [ rein ];
    platforms = [ "x86_64-linux" ];
  };
}

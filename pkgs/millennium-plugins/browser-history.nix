{
  lib,
  buildNpmPackage,
  esbuild,
  fetchFromGitHub,
  writeShellScriptBin,
}:
let
  fakeEsbuild = writeShellScriptBin "esbuild" ''
    if [ "$1" = "--version" ]; then
      echo "0.27.3"
    else
      exec ${lib.getExe esbuild} "$@"
    fi
  '';
in
buildNpmPackage (finalAttrs: {
  pname = "browser_history";

  version = "0-unstable-2026-03-05";

  src = fetchFromGitHub {
    owner = "ricewind012";
    repo = "steam-browser-history";
    rev = "e6ec2ab37a63c7ec245b7d893f7cf94a07fb45c3";
    hash = "sha256-Ed/I5vOYsZJWvvNyD0+5oZAYuqZvaP/6owrp3kLrh+8=";
  };

  npmDepsHash = "sha256-uB16oLWETaJ/Cv/8g5je1LLsJj/22aTCCjwQNEKk+Ro=";

  npmFlags = [ "--legacy-peer-deps" ];

  nativeBuildInputs = [ fakeEsbuild ];

  ESBUILD_BINARY_PATH = lib.getExe fakeEsbuild;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/.millennium/

    cp -r .millennium/Dist $out/.millennium
    cp plugin.json $out
    cp README.md $out

    runHook postInstall
  '';

  meta = {
    description = "A Millennium plugin to see your browser history on URL bar click";
    homepage = "https://github.com/ricewind012/steam-browser-history";
    maintainers = with lib.maintainers; [ rein ];
    platforms = [ "x86_64-linux" ];
  };
})

{
  lib,
  stdenv,
  fetchBunDeps,
  bun,
  nodejs,
  fetchFromGitHub,
}:
let
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "jcdoll";
    repo = "hltb-millennium-plugin";
    rev = "v${version}";
    hash = "sha256-q6hCSkviga/KuGOSlLuZP/QNLobi7bao3VuJJU/Tiss=";
  };

  node_modules = fetchBunDeps {
    pname = "hltb-bun-deps";
    inherit version src;
    hash = "sha256-aByhqc5tBKa//j8L0xSHAicLl6u3C+zPb7eijNvwKns=";
  };
in
stdenv.mkDerivation {
  pname = "hltb";
  inherit version src;

  nativeBuildInputs = [
    bun
    nodejs
  ];

  buildPhase = ''
    runHook preBuild
    cp ${./hltb.lock} ./bun.lock
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
    cp LICENSE $out
    cp README.md $out

    runHook postInstall
  '';

  passthru.node_modules = node_modules;

  meta = {
    description = "HLTB for Steam Homebrew (Millennium)";
    homepage = "https://github.com/jcdoll/hltb-millennium-plugin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rein ];
    platforms = [ "x86_64-linux" ];
  };
}

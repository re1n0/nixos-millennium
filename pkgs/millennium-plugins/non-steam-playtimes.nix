{
  lib,
  stdenv,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
  nodejs,
  fetchFromGitHub,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "non-steam-playtimes";

  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "k0d13";
    repo = "steam-non-steam-playtimes";
    rev = "v2.0.2";
    hash = "sha256-9cUoPaQvIF7/okMrlOvXVIiCzmnw59FPqEFvlLb8txc=";
  };

  nativeBuildInputs = [
    pnpm
    pnpmConfigHook
    nodejs
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    fetcherVersion = 4;
    hash = "sha256-TB1INBJhscsslY2A2xqjSQ+f/+CCm/sKb+dTwc2QVjc=";
  };

  buildPhase = ''
    runHook preBuild

    pnpm build

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

  meta = {
    description = "A Millennium plugin for tracking playtime of non-Steam apps ";
    homepage = "https://github.com/k0d13/steam-non-steam-playtimes";
    maintainers = with lib.maintainers; [ rein ];
    platforms = [ "x86_64-linux" ];
  };
})

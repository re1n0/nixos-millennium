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

  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "k0d13";
    repo = "steam-non-steam-playtimes";
    rev = "v2.0.3";
    hash = "sha256-xZHRBh2pv2AFKIpk5BN4lO0yxSTcsDfws0y8v9Lzze0=";
  };

  nativeBuildInputs = [
    pnpm
    pnpmConfigHook
    nodejs
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit
      (finalAttrs)
      pname
      version
      src
      ;
    fetcherVersion = 4;
    hash = "sha256-Kx3ORmqrt0JxZ2WWhcglcQJKPU4sCPsQLoWb5gyJOuE=";
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
    maintainers = with lib.maintainers; [rein];
    platforms = ["x86_64-linux"];
  };
})

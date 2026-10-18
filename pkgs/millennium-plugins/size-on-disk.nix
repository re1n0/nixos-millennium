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
  pname = "size-on-disk";

  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "k0d13";
    repo = "steam-size-on-disk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cPZx/PLqdcF+ahxzNPk8V8GcwA8qJq4iot3Bb31+yYg=";
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
    hash = "sha256-vJTNMUxi8WYZGOWNw4LQcj38kDxCgRO0LSOSVlMYSTE=";
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
    cp CHANGELOG.md $out

    runHook postInstall
  '';

  meta = {
    description = "A Millennium plugin that allows you to instantly see the size of a game on disk";
    homepage = "https://github.com/k0d13/steam-size-on-disk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [rein];
    platforms = ["x86_64-linux"];
  };
})

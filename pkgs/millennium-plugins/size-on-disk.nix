{
  lib,
  fetchFromGitHub,
  starlight,
  pnpm,
  pnpmConfigHook,
  fetchPnpmDeps,
  nodejs,
}:
starlight.buildStarlightPlugin (finalAttrs: {
  pname = "size-on-disk";

  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "k0d13";
    repo = "steam-size-on-disk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-zoQkL32Wu66298I3n1PaWcZKf67x3tMAZIBiAYeQGm0=";
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
    hash = "sha256-gJDFa4e7CQWBuc84nIGR0VoGFkoTcVPSj10lJfLgbzQ=";
  };

  meta = {
    description = "A Millennium plugin that allows you to instantly see the size of a game on disk";
    homepage = "https://github.com/k0d13/steam-size-on-disk";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [rein];
  };
})

{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "space-theme-steam";
  version = "20250912-unstable-2026-11-12";

  src = fetchFromGitHub {
    owner = "SpaceTheme";
    repo = "Steam";
    rev = "65bc106e8a1fe04c359d5b9d5c6f00e4081506ef";
    hash = "sha256-TjPGjKQLicT6nKp1iqKtNmHpeKhXZIekAmfZCLhFHic=";
  };

  installPhase = ''
    runHook preInstall
    cp -r . $out
    runHook postInstall
  '';

  meta = {
    description = "Space theme for the Steam client";
    homepage = "https://github.com/SpaceTheme/Steam";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [rein];
  };
}

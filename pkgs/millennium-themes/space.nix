{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation {
  pname = "space-theme-steam";
  version = "20250912-unstable-2026-10-04";

  src = fetchFromGitHub {
    owner = "SpaceTheme";
    repo = "Steam";
    rev = "17f93c585fe18056386ccf5a1cb1d47001be29d1";
    hash = "sha256-IgigkUKnZTWFKxk0qzkqNhyRPzjKsHSWho4BawLApg4=";
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

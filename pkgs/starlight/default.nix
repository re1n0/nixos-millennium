{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  nix-update-script,
  callPackage,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "starlight";
  version = "3.6.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "SteamClientHomebrew";
    repo = "Millennium";
    tag = "v3.6.2";
    hash = "sha256-mzX4U6sVJtsTtHYtnEsM305YwRDeeDbw21Az7Q0ovn4=";
    rootDir = "starlight";
  };

  cargoHash = "sha256-eWcwtiuQ4sCSY4oiEJfF8BI53JyE4D0Usb62D5q3T50=";

  nativeBuildInputs = [
    pkg-config
  ];

  passthru.buildStarlightPlugin = callPackage ./build-plugin.nix {
    starlight = finalAttrs.finalPackage;
  };

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "A compiler tool for Millennium plugins";
    homepage = "https://github.com/SteamClientHomebrew/Millennium/tree/main/starlight";
    changelog = "https://github.com/SteamClientHomebrew/Millennium/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [rein];
    mainProgram = "starlight";
  };
})

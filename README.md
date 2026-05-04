# NixOS Millennium

Declarative configuration for Millennium Steam

## ❄️ Flake

In order to use this, you need to include it in your flake's inputs like this:

```nix
# flake.nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-millennium = {
      url = "github:re1n0/nixos-millennium";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, ...}@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        inputs.nixos-millennium.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
```

The module supports Stylix and will apply the default theme as long, as Stylix is installed with Home Manager and `stylix.targets.steam.enable = true`.

## ⚙ Example Configuration

```nix
# home.nix
{
  # ...

  programs.steam.theme = pkgs.millenniumThemes.adwaita;

  programs.steam.config = {
    themes.conditions."adwaita" = {
      "Login QR code" = "Show";
      "Keep pointer cursor for clickable elements" = "yes";
      "Remove rounded corners" = "yes";
      "Show Library sidebar on hover" = "no";
      "Show URL" = "yes";
      "Window controls layout" = "Adwaita";
      "Window controls theme" = "Breeze (KDE)";
    };
  };

  programs.steam.plugins = with pkgs.millenniumPlugins; [ extendium ];

  # ...
}
```

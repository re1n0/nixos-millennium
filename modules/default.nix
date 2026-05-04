{
  lib,
  self,
  ...
}:
{
  flake.nixosModules.default =
    { options, pkgs, ... }:
    lib.mkMerge [
      (lib.optionalAttrs (options ? home-manager) {
        home-manager.sharedModules = [
          self.homeManagerModules.default
        ]
        ++ lib.optionals (options ? stylix) [ self.homeManagerModules.stylix ];
      })

      {
        nixpkgs.overlays = [
          self.overlays.default
        ];

        nix.settings.trusted-public-keys = [
          "nixos-millennium.cachix.org-1:AaMK3uqfgzCUpjs7+gdHTwwaqkT/vvLMCnUKSY37QAQ="
        ];

        nix.settings.substituters = [
          "https://nixos-millennium.cachix.org"
        ];

        programs.steam.package = lib.mkDefault pkgs.millennium-steam;
      }
    ];
}

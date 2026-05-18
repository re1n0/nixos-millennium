{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.stylix.targets.millenniumSteam.enable =
    config.lib.stylix.mkEnableTarget "Millennium Steam" true;

  config = lib.mkIf (config.stylix.enable && config.stylix.targets.millenniumSteam.enable) {
    programs.steam.theme = lib.mkDefault pkgs.millenniumThemes.space;

    programs.steam.millenniumConfig.themes.themeColors."space-theme-steam" =
      let
        hexToRGB =
          hex:
          let
            r = lib.fromHexString (builtins.substring 0 2 hex);
            g = lib.fromHexString (builtins.substring 2 2 hex);
            b = lib.fromHexString (builtins.substring 4 2 hex);
          in
          "${toString r}, ${toString g}, ${toString b}";
      in
      with config.lib.stylix.colors;
      {
        "--st-background" = hexToRGB base11;

        "--st-accent-1" = hexToRGB base0D;
        "--st-accent-2" = hexToRGB base16;

        "--st-color-1" = hexToRGB base10;
        "--st-color-2" = hexToRGB base00;
        "--st-color-3" = hexToRGB base01;
        "--st-color-4" = hexToRGB base02;
        "--st-color-5" = hexToRGB base03;

        "--st-blue" = hexToRGB base0D;
        "--st-blue-hover" = hexToRGB base16;

        "--st-green" = hexToRGB base0B;
        "--st-green-hover" = hexToRGB base14;

        "--st-red" = hexToRGB base08;
        "--st-red-hover" = hexToRGB base12;

        "--st-yellow" = hexToRGB base0A;
        "--st-yellow-hover" = hexToRGB base13;
      };
  };
}

{
  lib,
  config,
}:
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
  default = {
    "--adw-accent-bg-rbg" = hexToRGB base0D;
    "--adw-accent-fg-rbg" = hexToRGB base00;
    "--adw-accent-rgb" = hexToRGB base0D;

    "--adw-destructive-bg-rgb" = hexToRGB base08;
    "--adw-destructive-fg-rgb" = hexToRGB base00;
    "--adw-destructive-rgb" = hexToRGB base08;

    "--adw-success-bg-rgb" = hexToRGB base0B;
    "--adw-success-fg-rgb" = hexToRGB base00;
    "--adw-success-rgb" = hexToRGB base0B;

    "--adw-warning-bg-rgb" = hexToRGB base0E;
    "--adw-warning-fg-rgb" = hexToRGB base00;
    "--adw-warning-fg-a" = "0.8";
    "--adw-warning-rgb" = hexToRGB base0E;

    "--adw-error-bg-rgb" = hexToRGB base08;
    "--adw-error-fg-rgb" = hexToRGB base00;
    "--adw-error-rgb" = hexToRGB base08;

    "--adw-window-bg-rgb" = hexToRGB base00;
    "--adw-window-fg-rgb" = hexToRGB base05;
    "--adw-view-bg-rgb" = hexToRGB base00;
    "--adw-view-fg-rgb" = hexToRGB base05;

    "--adw-headerbar-bg-rgb" = hexToRGB base01;
    "--adw-headerbar-fg-rgb" = hexToRGB base05;
    "--adw-headerbar-border-rgb" = hexToRGB base01;
    "--adw-headerbar-backdrop-rgb" = hexToRGB base00;
    "--adw-headerbar-shade-rgb" = "0, 0, 0";
    "--adw-headerbar-shade-a" = "0.9";

    "--adw-sidebar-bg-rgb" = hexToRGB base01;
    "--adw-sidebar-fg-rgb" = hexToRGB base05;
    "--adw-sidebar-backdrop-rgb" = hexToRGB base00;
    "--adw-sidebar-shade-rgb" = "0, 0, 0";
    "--adw-sidebar-shade-a" = "0.36";

    "--adw-secondary-sidebar-bg-rgb" = hexToRGB base01;
    "--adw-secondary-sidebar-fg-rgb" = hexToRGB base05;
    "--adw-secondary-sidebar-backdrop-rgb" = hexToRGB base00;
    "--adw-secondary-sidebar-shade-rgb" = "0, 0, 0";
    "--adw-secondary-sidebar-shade-a" = "0.36";

    "--adw-card-bg-rgb" = "0, 0, 0";
    "--adw-card-bg-a" = "0.08";
    "--adw-card-fg-rgb" = hexToRGB base05;
    "--adw-card-shade-rgb" = "0, 0, 0";
    "--adw-card-shade-a" = "0.36";

    "--adw-dialog-bg-rgb" = hexToRGB base01;
    "--adw-dialog-fg-rgb" = hexToRGB base05;
    "--adw-popover-bg-rgb" = hexToRGB base01;
    "--adw-popover-fg-rgb" = hexToRGB base05;
    "--adw-popover-shade-rgb" = hexToRGB base01;
    "--adw-popover-shade-a" = "0.36";

    "--adw-thumbnail-bg-rgb" = hexToRGB base00;
    "--adw-thumbnail-fg-rgb" = hexToRGB base05;
    "--adw-shade-rgb" = "0, 0, 0";
    "--adw-shade-a" = "0.36";
  };
}

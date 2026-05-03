{ lib, config, ... }:
{
  options = lib.mkIf (config ? stylix) {
    stylix.targets.steam.enable = lib.mkOption {
      description = "Millennium Steam";
      type = lib.types.bool;
      default = config.stylix.autoEnable or false;
    };
  };
}

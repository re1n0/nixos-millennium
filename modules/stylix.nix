{ config, lib, ... }:
{
  options.stylix.targets.steam.enable = lib.mkOption {
    description = "Millennium Steam";
    type = lib.types.bool;
    default = config.stylix.autoEnable or true;
  };
}

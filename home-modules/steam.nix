{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.steam;
  jsonFormat = pkgs.formats.json { };
in
{
  options.programs.steam = {
    theme =
      with lib;
      mkOption {
        type = types.nullOr types.package;
        default = null;
        description = "The theme package to apply for Millennium Steam";
        example = pkgs.milleniumThemes.space;
      };

    millenniumConfig =
      with lib;
      mkOption {
        type = types.submodule {
          freeformType = jsonFormat.type;
        };
        description = "Configuration for Millennium";
      };

    plugins =
      with lib;
      mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = "Millennium Steam plugins.";
        example = [ pkgs.millenniumPlugins.extendium ];
      };

    # extensions =
    #   with lib;
    #   mkOption {
    #     type = types.listOf types.str;
    #     default = [ ];
    #     description = "List of Chromium extensions IDs for Extendium";
    #     example = [
    #       "cjpalhdlnbpafiamejdnhcphjbkeiagm"
    #     ];
    #   };
  };

  config = lib.mkMerge [
    {
      programs.steam.millenniumConfig = lib.mkMerge [
        {
          general = {
            checkForMillenniumUpdates = false;
            checkForPluginAndThemeUpdates = false;
            onMillenniumUpdate = 0;
            shouldShowThemePluginUpdateNotifications = false;
          };

          misc.hasShownWelcomeModal = true;

          notifications = {
            showUpdateNotifications = false;
          };

          plugins.enabledPlugins = map (pkg: pkg.pname) cfg.plugins;
        }

        (lib.mkIf (cfg.theme != null) {
          themes.activeTheme = cfg.theme.pname or "custom-theme";
        })
      ];
    }

    (lib.mkIf (cfg.theme != null) {
      home.file.".local/share/Steam/millennium/themes/${cfg.theme.pname or "custom-theme"}".source =
        cfg.theme;
    })

    {
      home.file = builtins.listToAttrs (
        map (pkg: {
          name = ".local/share/millennium/plugins/${pkg.pname or pkg.name}";
          value = {
            source = pkg;
            recursive = true;
          };
        }) cfg.plugins
      );
    }

    {
      xdg.configFile."millennium/config.json" = lib.mkIf (cfg.millenniumConfig != { }) {
        source = jsonFormat.generate "config.json" cfg.millenniumConfig;
        force = true;
      };
    }
  ];
}

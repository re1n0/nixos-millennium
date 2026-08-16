{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.steam;
  jsonFormat = pkgs.formats.json { };

  chromeWebStoreUpdateUrl = "https://clients2.google.com/service/update2/crx";
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

    extensions =
      with lib;
      mkOption {
        type =
          let
            extensionType = types.submodule {
              options = {
                id = mkOption {
                  type = types.strMatching "[a-zA-Z]{32}";
                  description = ''
                    The extension's ID from the Chrome Web Store url or the unpacked crx.
                  '';
                  default = "";
                };

                updateUrl = mkOption {
                  type = types.str;
                  default = chromeWebStoreUpdateUrl;
                  description = ''
                    URL of the extension's update manifest XML file.
                  '';
                };

                crxPath = mkOption {
                  type = types.nullOr types.path;
                  default = null;
                  description = ''
                    Path to the extension's crx file.
                  '';
                };

                version = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = ''
                    The extension's version, required for local installation.
                  '';
                };
              };
            };
          in
          types.listOf (types.coercedTo types.str (v: { id = v; }) extensionType);
        default = [ ];
        example = literalExpression ''
          [
            { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # ublock origin
            { id = "aaaaaaaaaabbbbbbbbbbcccccccccc"; crxPath = "/home/share/extension.crx"; version = "1.0"; }
          ]
        '';
        description = ''
          List of Chromium extensions for Extendium to install.
          To find the extension ID, check its URL on the
          [Chrome Web Store](https://chrome.google.com/webstore/category/extensions).

          To install extensions outside of the Chrome Web Store set
          `updateUrl` or `crxPath` and
          `version` as explained in the
          [Chrome
          documentation](https://developer.chrome.com/docs/extensions/mv2/external_extensions).
        '';
      };
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

          plugins.enabledPlugins = lib.lists.uniqueStrings (map (pkg: pkg.pname) cfg.plugins);
        }

        (lib.mkIf (cfg.theme != null) {
          themes.activeTheme = cfg.theme.pname or "custom-theme";
        })
      ];
    }

    (lib.mkIf (cfg.extensions != [ ]) {
      programs.steam.plugins = [ pkgs.millenniumPlugins.extendium ];

      xdg.configFile."millennium/extendium-extensions.json".text = builtins.toJSON (
        map (
          ext:
          assert ext.crxPath != null -> ext.version != null;
          if ext.crxPath != null then
            {
              inherit (ext) id;
              external_crx = ext.crxPath;
              external_version = ext.version;
            }
          else
            {
              inherit (ext) id;
              external_update_url = ext.updateUrl;
            }
        ) cfg.extensions
      );
    })

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
        }) (lib.lists.unique cfg.plugins)
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

{
  lib,
  stdenv,
  starlight,
  luajit,
}:
lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;

  excludeDrvArgNames = ["id"];

  extendDrvArgs = finalAttrs: {
    id ? null,
    nativeBuildInputs ? [],
    passthru ? {},
    ...
  } @ args: let
    tomlPath = args.src + "/millennium.toml";

    pluginId =
      if id != null
      then id
      else if !(builtins.pathExists tomlPath)
      then throw "starlight plugin '${args.pname}': no millennium.toml"
      else (lib.importTOML tomlPath).plugin.id
          or (throw "starlight plugin '${args.pname}': millennium.toml has no `plugin.id` key");
  in {
    nativeBuildInputs = [starlight luajit] ++ nativeBuildInputs;

    buildPhase =
      args.buildPhase or ''
        runHook preBuild
          
        mkdir build
        starlight pack --release -o build

        runHook postBuild
      '';

    checkPhase =
      args.checkPhase or ''
        runHook preCheck

        starlight verify build/${pluginId}.star

        runHooke postCheck
      '';

    installPhase =
      args.installPhase or ''
        runHook preInstall

        mkdir -p $out
        cp -r build/${pluginId}.star $out

        runHook postInstall
      '';

    passthru = passthru // {inherit pluginId;};

    meta = (args.meta or {}) // {platforms = args.meta.platforms or starlight.meta.platforms;};
  };
}

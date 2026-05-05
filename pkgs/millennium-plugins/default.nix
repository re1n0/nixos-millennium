{
  stdenvNoCC,
  bun,
  callPackage,
}:
let
  fetchBunDeps =
    { src, hash, ... }@args:
    stdenvNoCC.mkDerivation {
      pname = args.pname or "${src.name or "source"}-bun-deps";
      version = args.version or "unknown";
      inherit src;

      nativeBuildInputs = [ bun ];

      buildPhase = ''
        export HOME=$TMPDIR
        bun install --no-progress --frozen-lockfile --ignore-scripts
      '';

      installPhase = ''
        mkdir -p $out
        cp -R ./node_modules $out
        cp ./bun.lock $out/
      '';

      dontFixup = true;
      outputHash = hash;
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
{
  extendium = callPackage ./extendium.nix { inherit fetchBunDeps; };
  gratitude = callPackage ./gratitude.nix { };
  # hltb = callPackage ./hltb.nix { };
}

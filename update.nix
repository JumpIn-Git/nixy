let
  flake = toString ./. |> builtins.getFlake;
  new = builtins.getFlake "github:nixos/nixpkgs";
  pkgs = new.legacyPackages.x86_64-linux;
in
  flake.nixosConfigurations.nixos.config.environment.systemPackages
  |> builtins.filter (
    p: let
      oldVer = p.version or null;
      matchingPkg =
        if builtins.hasAttr p.pname pkgs
        then pkgs.${p.pname}
        else null;

      newVer = matchingPkg.version or null;
    in
      oldVer
      != null
      && newVer != null
      && (builtins.compareVersions newVer oldVer) == 1
  )

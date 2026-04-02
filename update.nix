let
  flake = toString ./. |> builtins.getFlake;
  pkgs = (builtins.getFlake "github:nixos/nixpkgs").legacyPackages.x86_64-linux;
in
  flake.nixosConfigurations.nixos.config.environment.systemPackages
  |> builtins.filter (
    p:
      p ? version
      && pkgs ? ${p.pname}
      && pkgs.${p.pname} ? version
      && builtins.compareVersions pkgs.${p.pname}.version p.version == 1
  )
  |> map (p: p.pname)
  |> flake.inputs.nixpkgs.lib.unique

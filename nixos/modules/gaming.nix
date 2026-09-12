{
  flake.nixosModules.gaming = {
    pkgs,
    inputs,
    ...
  }: {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = let
          extracted = pkgs.runCommand "extract-7z" {nativeBuildInputs = [pkgs.p7zip];} ''
            7z x ${inputs.slssteam} -o$out
          '';
        in {
          LD_AUDIT = "${extracted}/bin/library-inject.so:${extracted}/bin/SLSsteam.so";
        };
      };
      extraCompatPackages = [pkgs.proton-ge-bin];
    };

    services.ratbagd.enable = true;
    environment.systemPackages = with pkgs; [
      piper
      prismlauncher
      samrewritten
    ];
  };
}

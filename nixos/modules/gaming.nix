{
  flake.nixosModules.gaming = {pkgs, ...}: {
    programs = {
      steam = {
        enable = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
      gamemode = {
        enable = true;
        enableRenice = true;
        settings = {
          general.renice = 10;
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        };
      };
    };

    services.ratbagd.enable = true;
    environment.systemPackages = with pkgs; [
      piper
      prismlauncher
      samrewritten
    ];
  };
}

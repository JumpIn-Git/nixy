{
  flake.nixosModules.virt = {pkgs, ...}: {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };
    virtualisation.waydroid.enable = true;
    virtualisation.waydroid.package = pkgs.waydroid-nftables;

    environment.etc."distrobox/distrobox.conf".text = ''
      container_additional_volumes="/nix/store:/nix/store:ro /run/current-system:/run/current-system:ro /run/wrappers:/run/wrappers:ro"
    '';

    environment.systemPackages = with pkgs; [
      distrobox
      qemu
      waydroid-helper
    ];
  };
}

{
  flake.nixosModules.virt = {pkgs, ...}: {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
    };

    environment.etc."distrobox/distrobox.conf".text = ''
      container_additional_volumes="/nix/store:/nix/store:ro /run/current-system:/run/current-system:ro /run/wrappers:/run/wrappers:ro"
    '';

    environment.systemPackages = with pkgs; [
      distrobox
      qemu
    ];
  };
}

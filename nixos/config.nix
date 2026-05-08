{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./system.nix
    ./niri.nix
    inputs.n-i-d.nixosModules.default
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  environment.etc."distrobox/distrobox.conf".text = ''
    container_additional_volumes="/nix/store:/nix/store:ro /run/current-system:/run/current-system:ro /run/wrappers:/run/wrappers:ro"
  '';
  programs = {
    localsend.enable = true;
    git.enable = true;
    nix-ld.enable = true;
    nix-index-database.comma.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
    };
    steam = {
      enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };
  };

  users.users.cinnamon = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "input"];
    shell = pkgs.nushell;
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    registry.n.flake = inputs.nixpkgs-unfree;
    channel.enable = false;
    settings = {
      auto-optimise-store = true;
      experimental-features = ["flakes" "nix-command" "pipe-operators"];
      trusted-users = ["@wheel"];
    };
  };

  services.ratbagd.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  environment.systemPackages = with pkgs; [
    gpu-screen-recorder
    # dev
    distrobox
    uv

    nixd
    alejandra
    lua-language-server
    love

    gh
    lazygit
    gemini-cli

    zed-editor

    # hw
    piper
    libnotify
    usbutils

    # cli
    btop
    dua
    ripgrep
    fd
    (inputs.wrappers.wrappers.nushell.wrap {
      inherit pkgs;
      extraPackages = with pkgs; [microfetch carapace];
      #nu
      "config.nu".content = ''
        $env.FLAKE = '/home/cinnamon/nix'
        $env.NH_FLAKE = $env.FLAKE

        $env.config.show_banner = false
        if (is-terminal --stdout) {
          microfetch
        }
        $env.config = {
            completions: {
                external: {
                    enable: true
                    completer: {|spans|
                        carapace $spans.0 nushell ...$spans | from json
                    }
                }
            }
        }
      '';
    })

    # web
    discord
    parabolic
    loupe
    qbittorrent
    inputs.helium.packages.${system}.default
    proton-pass
  ];
  services.flatpak.enable = true;
  services.flatpak.packages = [
    "com.stremio.Stremio"
    "com.modrinth.ModrinthApp"
  ];

  system.stateVersion = "25.11";
}

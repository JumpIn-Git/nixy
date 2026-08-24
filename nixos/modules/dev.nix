{
  flake.nixosModules.dev = {pkgs, ...}: {
    programs.direnv.enable = true;
    environment.localBinInPath = true;
    environment.systemPackages = with pkgs; [
      uv
      gh
      lazygit
      opencode
      sqlc
      goose
      zed-editor
      cachix
      ventoy-full-gtk
      (symlinkJoin {
        name = "recaf-launcher-with-desktop";
        paths = [recaf-launcher];
        nativeBuildInputs = [copyDesktopItems];
        desktopItems = [
          (makeDesktopItem {
            name = "recaf-launcher";
            desktopName = "Recaf";
            comment = "Java Bytecode Editor";
            exec = "recaf-launcher";
            icon = "java";
            terminal = false;
            categories = ["Development" "IDE"];
          })
        ];
        postBuild = ''
          copyDesktopItems
        '';
      })

      nixd
      alejandra
      lua-language-server
      lua
      love
      go
      gcc
      gopls
      basedpyright
      ruff
    ];
    nixpkgs.config.permittedInsecurePackages = [
      "ventoy-1.1.17"
      "ventoy-gtk3-1.1.17"
    ];

    environment.variables = {
      EDITOR = "zeditor --wait";
      VISUAL = "zeditor --wait";
    };
    xdg.mime.defaultApplications."text/plain" = "dev.zed.Zed.desktop";
  };
}

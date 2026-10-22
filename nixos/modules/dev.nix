{
  flake.nixosModules.dev = {
    pkgs,
    lib,
    ...
  }: {
    programs.direnv.enable = true;
    environment.localBinInPath = true;
    environment.systemPackages = with pkgs; [
      uv
      gh
      lazygit
      sqlc
      goose
      zed-editor
      cachix
      ventoy-full-gtk
      qwen-code

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
    nixpkgs.config.allowInsecurePredicate = pkg:
      lib.hasPrefix "ventoy" (lib.getName pkg);

    environment.variables = {
      EDITOR = "zeditor --wait";
      VISUAL = "zeditor --wait";
    };
    xdg.mime.defaultApplications."text/plain" = "dev.zed.Zed.desktop";
  };
}

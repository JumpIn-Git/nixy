{
  flake.nixosModules.dev = {pkgs, ...}: {
    programs.direnv.enable = true;
    environment.localBinInPath = true;
    environment.systemPackages = with pkgs; [
      uv
      gh
      lazygit
      opencode
      antigravity-cli
      sqlc
      zed-editor
      cachix

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

    environment.variables = {
      EDITOR = "zeditor --wait";
      VISUAL = "zeditor --wait";
    };
    xdg.mime.defaultApplications = {
      "text/plain" = "dev.zed.Zed.desktop";
    };
  };
}

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
  };
}

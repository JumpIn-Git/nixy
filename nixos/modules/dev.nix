{
  flake.nixosModules.dev = {pkgs, ...}: {
    programs.direnv.enable = true;
    environment.systemPackages = with pkgs; [
      uv
      gh
      lazygit
      opencode
      zed-editor

      nixd
      alejandra
      lua-language-server
      lua
      love
      go
    ];
  };
}

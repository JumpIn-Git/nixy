{
  flake.nixosModules.dev = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      uv
      gh
      lazygit
      antigravity-cli
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

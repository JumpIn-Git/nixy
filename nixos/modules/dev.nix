{
  flake.nixosModules.dev = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      uv
      gh
      lazygit
      gemini-cli
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

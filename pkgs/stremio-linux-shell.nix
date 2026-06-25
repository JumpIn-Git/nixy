{
  perSystem = {pkgs, ...}: {
    packages = {
      inherit (pkgs) stremio-linux-shell;
      # Just for cachix to cache the unfree package
    };
  };
}

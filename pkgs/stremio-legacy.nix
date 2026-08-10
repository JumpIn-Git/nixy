{inputs, ...}: {
  perSystem = {system, ...}: {
    # export it here so it will be saved in cachix
    packages.stremio-legacy =
      (import inputs.nixpkgs-stremio {
        inherit system;
        config = {
          allowUnfree = true;
          permittedInsecurePackages = ["qtwebengine-5.15.19"];
        };
      }).stremio;
  };
}

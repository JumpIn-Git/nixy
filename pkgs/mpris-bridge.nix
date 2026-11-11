{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.mpris-bridge = pkgs.python3Packages.buildPythonApplication {
      pname = "mpris-bridge";
      version = "1";
      src = inputs.mpris-bridge;
      format = "pyproject";
      propagatedBuildInputs = with pkgs.python3Packages; [
        setuptools
        flask
        certifi
        dbus-python
      ];
      meta.mainProgram = "mpris-bridge";
    };
  };
}

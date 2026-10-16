{
  perSystem = {pkgs, ...}: {
    packages.go-clicker = pkgs.buildGoModule {
      pname = "go-clicker";
      version = "0.1.0";
      src = ./.;

      vendorHash = null;

      nativeBuildInputs = [ pkgs.makeWrapper ];

      postInstall = ''
        wrapProgram $out/bin/go-clicker \
          --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.ydotool pkgs.libnotify]}
      '';
    };
  };
}

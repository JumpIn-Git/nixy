{pkgs ? import <nixpkgs> {}}: let
  pname = "ACCELA";
  version = "20260204095000";

  srcArchive = pkgs.fetchzip {
    url = "https://github.com/ciscosweater/enter-the-wired/releases/download/${version}/ACCELA-${version}-linux-appimage.tar.gz";
    hash = "sha256-W/5mWeR1TQgila1oFLo4VDwGtxKHZMjj1dRgipHtJmw=";
    stripRoot = false;
  };
  contents = pkgs.appimageTools.extract {
    inherit pname version;
    src = "${srcArchive}/bin/ACCELA.AppImage";
  };
in
  pkgs.appimageTools.wrapType2 {
    inherit pname version;
    src = "${srcArchive}/bin/ACCELA.AppImage";
    extraPkgs = p:
      with p; [
        zstd
        libva
        libGL
      ];
    extraInstallCommands = ''
      install -D ${contents}/ACCELA.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/ACCELA.desktop \
          --replace-warn "Exec=run.sh" "Exec=ACCELA"
      install -D ${contents}/accela.png -t $out/share/icons/hicolor/512x512/apps/
    '';
  }

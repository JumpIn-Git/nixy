{
  perSystem = {pkgs, ...}: {
    packages.zennotes = let
      pname = "ZenNotes";
      version = "2.7.0";
      src = pkgs.fetchurl {
        url = "https://github.com/${pname}/zennotes/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
        hash = "sha256-i604+ITaO6KIcZGqx6ljg2VJofaM0jj+Lzv9cU4S4ws=";
      };

      contents = pkgs.appimageTools.extract {
        inherit pname version src;
      };
    in
      pkgs.appimageTools.wrapType2 {
        inherit pname version src;
        extraInstallCommands = ''
          install -D ${contents}/${pname}.desktop $out/share/applications/${pname}.desktop
          substituteInPlace $out/share/applications/${pname}.desktop \
              --replace-fail 'Exec=AppRun' 'Exec=${pname}'

          cp -r ${contents}/usr/share/icons $out/share/
        '';
      };
  };
}

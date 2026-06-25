{
  perSystem = {pkgs, ...}: {
    packages.zennotes = let
      pname = "ZenNotes";
      version = "2.7.0";
    in
      pkgs.appimageTools.wrapType2 {
        inherit pname version;
        src = pkgs.fetchurl {
          url = "https://github.com/${pname}/zennotes/releases/download/v${version}/${pname}-${version}-linux-x86_64.AppImage";
          hash = "sha256-i604+ITaO6KIcZGqx6ljg2VJofaM0jj+Lzv9cU4S4ws=";
        };
      };
  };
}

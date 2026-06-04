{
  flake.wrappers.mpv = {
    wlib,
    pkgs,
    ...
  }: {
    imports = [wlib.wrapperModules.mpv];
    script.modernz = {
      path = pkgs.mpvScripts.modernz;
    };
    "mpv.conf".content = ''
      osc=no
    '';
  };
}

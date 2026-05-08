{
  flake.wrappers.noctalia = {
    pkgs,
    wlib,
    ...
  }: let
    path = "~/nix/config/noctalia";
  in {
    imports = [wlib.modules.default];
    package = pkgs.noctalia-shell;
    extraPackages = [pkgs.sqlite];
    env.NOCTALIA_CONFIG_DIR = path;
    runShell = [
      # Nice hack, makes config work on systems without repo cloned and changes are written in my local repo
      ''
        mkdir -p ${path} && \
        cp -rn ${../noctalia}/. ${path}
        find ${path} ! -perm -u+w -exec chmod u+w {} +
      ''
    ];
  };
}

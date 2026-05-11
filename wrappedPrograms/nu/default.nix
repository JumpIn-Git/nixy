{
  flake.wrappers.nu = {
    pkgs,
    wlib,
    ...
  }: {
    imports = [wlib.wrapperModules.nushell];
    extraPackages = with pkgs; [carapace microfetch];
    "config.nu".path = ./config.nu;
  };
}

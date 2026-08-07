{
  flake.wrappers.nvim = {
    wlib,
    pkgs,
    ...
  }: {
    imports = [wlib.wrapperModules.neovim];
    config.specs.plugins.data = with pkgs.vimPlugins; [
      blink-cmp
      mini-files
      mini-icons
    ];
  };
}

{
  flake.wrappers.nu = {
    pkgs,
    wlib,
    ...
  }: {
    imports = [wlib.wrapperModules.nushell];
    runtimePkgs = with pkgs; [carapace microfetch];
    "config.nu".content = ''
      $env.FLAKE = '/home/cinnamon/nix'
      $env.NH_FLAKE = $env.FLAKE
      source ${pkgs.nix-your-shell.generate-config "nu"}

      $env.config = {
        show_banner: false
        completions: {
          external: {
            enable: true
            completer: {|spans|
              carapace $spans.0 nushell ...$spans | from json
            }
          }
        }
      }

      if (is-terminal --stdout) {
        microfetch
      }
    '';
  };
}

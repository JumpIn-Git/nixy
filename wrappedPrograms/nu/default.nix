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

      use std/config *

      $env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []
      $env.config.hooks.env_change.PWD ++= [{||
        if (which direnv | is-empty) {return}
        direnv export json | from json | default {} | load-env
        # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
        $env.PATH = do (env-conversions).path.from_string $env.PATH
      }]
    '';
  };
}

{
  flake.wrappers.nu = {
    pkgs,
    wlib,
    ...
  } @ top: {
    imports = [wlib.wrapperModules.nushell];
    config.runtimePkgs = with pkgs; [carapace microfetch];
    config."config.nu".content = ''
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

      alias own = sudo chown $"($env.USER):(id -gn)"

      use std/config env-conversions
      $env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []
      $env.config.hooks.env_change.PWD ++= [{||
        if (which direnv | is-empty) {return}
        direnv export json | from json | default {} | load-env
        # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
        $env.PATH = do (env-conversions).path.from_string $env.PATH
      }]
    '';
    config.install.modules.nixos = {
      config,
      lib,
      ...
    }: let
      wrapperCfg = top.config.install.getWrapperConfig config;
    in {
      config = lib.mkIf wrapperCfg.enable {
        environment.shells = [
          "/run/current-system/sw/bin/nu"
          (lib.getExe wrapperCfg.wrapper)
        ];
      };
    };
  };
}

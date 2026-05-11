$env.FLAKE = '/home/cinnamon/nix'
$env.NH_FLAKE = $env.FLAKE

$env.config.show_banner = false
if (is-terminal --stdout) {
  microfetch
}
$env.config = {
    completions: {
        external: {
            enable: true
            completer: {|spans|
                carapace $spans.0 nushell ...$spans | from json
            }
        }
    }
}

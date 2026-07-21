{self, ...}: {
  flake.wrappers.niri = {
    lib,
    wlib,
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.wrapperModules.niri];
    options.terminal = lib.mkOption {
      type = lib.types.package;
      default = pkgs.ghostty;
    };
    options.noctalia = lib.mkOption {
      type = lib.types.package;
      description = "Wrapped noctalia";
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia;
    };

    config.package = pkgs.niri-unstable;
    config.drv = {
      inherit (config.package) cargoBuildNoDefaultFeatures cargoBuildFeatures; # niri flake uses this
    };
    config.runtimePkgs = with pkgs; [wl-clipboard];

    config.extraSettings = [
      {include = [{optional = true;} "~/.config/niri/noctalia.kdl"];}
      {include = [{optional = true;} "~/.config/niri/monitors.kdl"];}
    ];
    config.settings = let
      noctaliaExe = lib.getExe config.noctalia;
      null = _: {};
      f = props: content: _: {inherit props content;};
    in {
      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
      debug.honor-xdg-activation-with-invalid-serial = null;
      # output = f ["eDP-1"] {scale = 1.1;};
      input = {
        workspace-auto-back-and-forth = null;
        focus-follows-mouse = null;
        touchpad = {
          tap = null;
          natural-scroll = null;
        };
      };
      spawn-at-startup = [
        noctaliaExe
        (lib.getExe pkgs.wl-gammarelay-rs)
      ];
      hotkey-overlay.skip-at-startup = null;
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      prefer-no-csd = null;
      animations.slowdown = 1.4;
      cursor = {
        xcursor-theme = "Bibata-Modern-Classic";
        xcursor-size = 20;
      };
      window-rule = {
        geometry-corner-radius = 9;
        clip-to-geometry = true;
      };
      layout = {
        gaps = 5;
        focus-ring.off = null;
        border = {
          on = null;
          width = 4;
        };
      };

      binds = let
        n = lib.range 1 9;
        ipc = cmd: {spawn = [noctaliaExe "ipc" "call"] ++ lib.splitString " " cmd;};
      in
        {
          "Mod+X" = ipc "sessionMenu toggle";
          "Mod+D" = ipc "launcher toggle";
          "Mod+S".spawn = lib.getExe config.wlr-which-key;
          "Mod+E".spawn = lib.getExe pkgs.nautilus;
          "Mod+T".spawn = lib.getExe config.terminal;
          XF86AudioRaiseVolume = f {allow-when-locked = true;} <| ipc "volume increase";
          XF86AudioLowerVolume = f {allow-when-locked = true;} <| ipc "volume decrease";
          XF86AudioMute = f {allow-when-locked = true;} <| ipc "volume muteOutput";
          XF86AudioMicMute = f {allow-when-locked = true;} <| ipc "volume muteInput";
          XF86MonBrightnessUp = f {allow-when-locked = true;} <| ipc "brightness increase";
          XF86MonBrightnessDown = f {allow-when-locked = true;} <| ipc "brightness decrease";

          "Mod+O" = f {repeat = false;} {toggle-overview = null;};
          "Mod+Q" = f {repeat = false;} {close-window = null;};
          "Mod+BracketLeft".consume-or-expel-window-left = null;
          "Mod+BracketRight".consume-or-expel-window-left = null;
          "Mod+R".switch-preset-column-width = null;
          "Mod+Shift+R".switch-preset-window-height = null;
          "Mod+Ctrl+R".reset-window-height = null;
          "Mod+F".maximize-column = null;
          "Mod+Shift+F".fullscreen-window = null;

          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";
          "Mod+Shift+Minus".set-window-height = "-10%";
          "Mod+Shift+Equal".set-window-height = "+10%";

          "Mod+V".toggle-window-floating = null;
          "Mod+Shift+V".switch-focus-between-floating-and-tiling = null;
          "Mod+W".toggle-column-tabbed-display = null;
          Print.screenshot = null;
          "Ctrl+Print".screenshot-screen = null;
          "Alt+Print".screenshot-window = null;
          "Mod+Escape" = f {allow-inhibiting = false;} {toggle-keyboard-shortcuts-inhibit = null;};
          "Mod+Shift+E".quit = null;

          "Mod+H".focus-column-left = null;
          "Mod+J".focus-window-down = null;
          "Mod+K".focus-window-up = null;
          "Mod+L".focus-column-right = null;

          "Mod+Shift+H".move-column-left = null;
          "Mod+Shift+J".move-window-down = null;
          "Mod+Shift+K".move-window-up = null;
          "Mod+Shift+L".move-column-right = null;

          "Mod+Ctrl+H".focus-monitor-left = null;
          "Mod+Ctrl+J".focus-monitor-down = null;
          "Mod+Ctrl+K".focus-monitor-up = null;
          "Mod+Ctrl+L".focus-monitor-right = null;

          "Mod+Alt+H".move-column-to-monitor-left = null;
          "Mod+Alt+J".move-column-to-monitor-down = null;
          "Mod+Alt+K".move-column-to-monitor-up = null;
          "Mod+Alt+L".move-column-to-monitor-right = null;
        }
        // lib.genAttrs' n (n: lib.nameValuePair "Mod+${toString n}" (f {repeat = false;} {focus-workspace = n;}))
        // lib.genAttrs' n (n: lib.nameValuePair "Mod+Shift+${toString n}" (f {repeat = false;} {move-column-to-workspace = n;}));
    };
  };
}

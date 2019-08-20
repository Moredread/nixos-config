{ pkgs, lib, config, ... }:
let
  myStuff = {
    i3.modKey = "Mod4";
    brightnessStep = "2.5";
    volumeStep = "2";
  };
  unstable = import <nixos-unstable> {};

  nixosConfig = (import <nixpkgs/nixos> {}).config;

  i3status-rust-config = valueForGrableOrMinuteman ./i3status-rust-config.toml ./i3status-rust-config-minuteman.toml;

  valueForGrableOrMinuteman = t: f: if nixosConfig.networking.hostName == "grable" then t else f;
in {

  xsession.enable = true;

  services = {
    blueman-applet.enable = true;
    dunst.enable = true;
    network-manager-applet.enable = true;
    #gpg-agent.enable = true;
    gpg-agent.defaultCacheTtl = 3 * 3600;
    gpg-agent.defaultCacheTtlSsh = 3 * 3600;
    gpg-agent.enableSshSupport = true;
    pasystray.enable = true;
  };

  xsession.windowManager.i3 = {
    enable = true;

    config.keybindings = with myStuff.i3; {
      "${modKey}+Return" =
        let factor = valueForGrableOrMinuteman "1.5" "2.0"; in
          "exec sh -c 'WINIT_HIDPI_FACTOR=${factor} ${pkgs.alacritty}/bin/alacritty'";
      "${modKey}+Shift+Return" =
        let factor = valueForGrableOrMinuteman "1.5" "2.0"; in
          "exec sh -c 'WINIT_HIDPI_FACTOR=${factor} ${pkgs.alacritty}/bin/alacritty --working-directory $(${pkgs.xcwd}/bin/xcwd)'";
      "${modKey}+Shift+q" = "kill";
      "${modKey}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";
      "${modKey}+p" = "exec ${pkgs.pass}/bin/passmenu";
      "${modKey}+Shift+p" = "exec ${pkgs.pass}/bin/passmenu --type";

      "${modKey}+Left" = "focus left";
      "${modKey}+Down" = "focus down";
      "${modKey}+Up" = "focus up";
      "${modKey}+Right" = "focus right";

      "${modKey}+j" = "focus left";
      "${modKey}+l" = "focus down";
      "${modKey}+k" = "focus up";
      "${modKey}+semicolon" = "focus right";

      "${modKey}+Shift+Left" = "move left";
      "${modKey}+Shift+Down" = "move down";
      "${modKey}+Shift+Up" = "move up";
      "${modKey}+Shift+Right" = "move right";

      "${modKey}+Shift+j" = "move left";
      "${modKey}+Shift+l" = "move down";
      "${modKey}+Shift+k" = "move up";
      "${modKey}+Shift+semicolon" = "move right";

      "${modKey}+h" = "split h";
      "${modKey}+v" = "split v";
      "${modKey}+f" = "fullscreen toggle";

      "${modKey}+s" = "layout stacking";
      "${modKey}+w" = "layout tabbed";
      "${modKey}+e" = "layout toggle split";

      "${modKey}+Shift+f" = "floating toggle";

      "${modKey}+grave" = "workspace 0";
      "${modKey}+1" = "workspace 1";
      "${modKey}+2" = "workspace 2";
      "${modKey}+3" = "workspace 3";
      "${modKey}+4" = "workspace 4";
      "${modKey}+5" = "workspace 5";
      "${modKey}+6" = "workspace 6";
      "${modKey}+7" = "workspace 7";
      "${modKey}+8" = "workspace 8";
      "${modKey}+9" = "workspace 9";
      "${modKey}+0" = "workspace 10";
      "${modKey}+minus" = "workspace 11";
      "${modKey}+equal" = "workspace 12";

      "${modKey}+Shift+grave" = "move container to workspace 0";
      "${modKey}+Shift+1" = "move container to workspace 1";
      "${modKey}+Shift+2" = "move container to workspace 2";
      "${modKey}+Shift+3" = "move container to workspace 3";
      "${modKey}+Shift+4" = "move container to workspace 4";
      "${modKey}+Shift+5" = "move container to workspace 5";
      "${modKey}+Shift+6" = "move container to workspace 6";
      "${modKey}+Shift+7" = "move container to workspace 7";
      "${modKey}+Shift+8" = "move container to workspace 8";
      "${modKey}+Shift+9" = "move container to workspace 9";
      "${modKey}+Shift+0" = "move container to workspace 10";
      "${modKey}+Shift+minus" = "move container to workspace 11";
      "${modKey}+Shift+equal" = "move container to workspace 12";

      "${modKey}+Shift+c" = "reload";
      "${modKey}+Shift+r" = "restart";
      "${modKey}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

      "${modKey}+Shift+space" = "move scratchpad";
      "${modKey}+space" = "scratchpad show";

      "${modKey}+r" = "mode resize";
   };

    extraConfig = with myStuff.i3; with pkgs; ''
      bindsym XF86AudioLowerVolume exec ${pamixer}/bin/pamixer -d ${myStuff.volumeStep}
      bindsym XF86AudioRaiseVolume exec ${pamixer}/bin/pamixer -i ${myStuff.volumeStep}
      bindsym XF86AudioMute exec ${pamixer}/bin/pamixer -t
      bindsym XF86AudioMicMute exec ${pamixer}/bin/pamixer --source "alsa_input.pci-0000_00_1f.3.analog-stereo" -t
      bindsym XF86MonBrightnessDown exec ${xorg.xbacklight}/bin/xbacklight -dec ${myStuff.brightnessStep}
      bindsym XF86MonBrightnessUp exec ${xorg.xbacklight}/bin/xbacklight -inc ${myStuff.brightnessStep}
      bindsym XF86WLAN exec $(${rfkill}/bin/rfkill list wlan | ${gnugrep}/bin/grep -e 'Soft blocked: yes' > /dev/null && ${rfkill}/bin/rfkill block wlan) || ${rfkill}/bin/rfkill unblock wlan
      bindsym XF86Sleep exec ${i3lock}/bin/i3lock

      bindsym Print exec ${scrot}/bin/scrot -e 'mkdir -p ~/.sync/sync/screenshots; mv $f ~/.sync/sync/screenshots'

      floating_modifier ${modKey}
    '';

    config.fonts = [ "DejaVu Sans Mono 12" ];

    config.bars = [ {
      statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${i3status-rust-config}";
    }
  ];

  config.startup = [
      {
        command = "sleep 5; ${pkgs.qsyncthingtray}/bin/QSyncthingTray"; always = true; notification = false;
      }
    ];
  };

  home.packages = with pkgs; [
    adapta-gtk-theme
    gnome3.adwaita-icon-theme
    hicolor-icon-theme
    lxappearance
    xorg.xcursorthemes
    zuki-themes
  ];
}

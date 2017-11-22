{ pkgs, ... }:

let
  myStuff = {
    i3.modKey = "Mod4";
  };
in {
  xsession.enable = true;

  services = {
    blueman-applet.enable = true;
    #keepassx.enable = true;
    network-manager-applet.enable = true;
    gpg-agent.enable = true;
  };

  xsession.windowManager.i3 = {
    enable = true;

    config.keybindings = with myStuff.i3; {
      "${modKey}+Return" = "exec i3-sensible-terminal";
      "${modKey}+Shift+q" = "kill";
      "${modKey}+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";

      "${modKey}+Left" = "focus left";
      "${modKey}+Down" = "focus down";
      "${modKey}+Up" = "focus up";
      "${modKey}+Right" = "focus right";

      "${modKey}+h" = "split h";
      "${modKey}+v" = "split v";
      "${modKey}+f" = "fullscreen toggle";

      "${modKey}+s" = "layout stacking";
      "${modKey}+w" = "layout tabbed";
      "${modKey}+e" = "layout toggle split";

      "${modKey}+Shift+space" = "floating toggle";

      "${modKey}+1" = "workspace 1";
      "${modKey}+2" = "workspace 2";
      "${modKey}+3" = "workspace 3";
      "${modKey}+4" = "workspace 4";
      "${modKey}+5" = "workspace 5";
      "${modKey}+6" = "workspace 6";
      "${modKey}+7" = "workspace 7";
      "${modKey}+8" = "workspace 8";
      "${modKey}+9" = "workspace 9";

      "${modKey}+Shift+1" = "move container to workspace 1";
      "${modKey}+Shift+2" = "move container to workspace 2";
      "${modKey}+Shift+3" = "move container to workspace 3";
      "${modKey}+Shift+4" = "move container to workspace 4";
      "${modKey}+Shift+5" = "move container to workspace 5";
      "${modKey}+Shift+6" = "move container to workspace 6";
      "${modKey}+Shift+7" = "move container to workspace 7";
      "${modKey}+Shift+8" = "move container to workspace 8";
      "${modKey}+Shift+9" = "move container to workspace 9";

      "${modKey}+Shift+c" = "reload";
      "${modKey}+Shift+r" = "restart";
      "${modKey}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

      "${modKey}+r" = "mode resize";
   };

    extraConfig = with pkgs; ''
      workspace 1 output DVI-I-1
      workspace 2 output DVI-I-1
      workspace 3 output DVI-I-1
      workspace 4 output DVI-I-1
      workspace 5 output DVI-I-1
      workspace 6 output DP-1
      workspace 7 output DP-1
      workspace 8 output DP-1
      workspace 9 output DP-1
      workspace 10 output DP-1

      bindsym XF86AudioLowerVolume exec ${pamixer}/bin/amixer -q set Master 5%-
      bindsym XF86AudioRaiseVolume exec ${pamixer}/bin/amixer -q set Master 5%+
      bindsym XF86AudioMute exec ${pamixer}/bin/amixer -q set Master toggle
      bindsym XF86AudioMicMute exec ${pamixer}/bin/amixer -q set Capture toggle
      bindsym XF86MonBrightnessDown exec ${xorg.xbacklight}/bin/xbacklight -dec 5
      bindsym XF86MonBrightnessUp exec ${xorg.xbacklight}/bin/xbacklight -inc 5
      bindsym XF86WLAN exec $(${rfkill}/bin/rfkill list wlan | ${gnugrep}/bin/grep -e 'Soft blocked: yes' > /dev/null && ${rfkill}/bin/rfkill block wlan) || ${rfkill}/bin/rfkill unblock wlan
      bindsym XF86Calculator exec ${i3lock}/bin/i3lock

      bindsym Print exec ${scrot}/bin/scrot

      #exec ${xorg.xrandr}/bin/xrandr --output DP-1 --mode 1920x1080 --left-of DVI-I-1
      exec ${dropbox}/bin/dropbox &
      exec xss-lock -v -- ${i3lock}/bin/i3lock -n &
      exec xautolock -locker ${i3lock}/bin/i3lock -time 5 -detectsleep &
      exec lxsession &
      #exec autocutsel -fork &
      #exec autocutsel -selection PRIMARY -fork &
      exec ${qsyncthingtray}/bin/QSyncthingTray &
    '';

    config.fonts = [ "DejaVu Sans Mono 10" ];
  };
}

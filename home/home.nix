{ pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in {
  home.packages = with pkgs; [
    apg
    atool
    blender
    borgbackup
    calibre
    daemontools
    evince
    love
    minecraft
    mplayer
    mpv
    nixops
    paperkey
    python3Packages.mps-youtube
    skype
    sloccount
    steam
    unzip
    daemontools
    subversion
    nixops
    vlc
    thunderbird
    youtube-dl
    yubioath-desktop
  ];

  programs = {
    home-manager.enable = true;
    home-manager.path = https://github.com/rycee/home-manager/archive/release-17.09.tar.gz;

    firefox.enable = true;
    browserpass.enable = true;
    htop.enable = true;
    #htop.detailedCpuTime = true;
    #htop.treeView = true;
    lesspipe.enable = true;
    man.enable = true;
  };

  xsession.enable = true;
  xsession.windowManager.i3.enable = true;

  services = {
    blueman-applet.enable = true;
    keepassx.enable = true;
    network-manager-applet.enable = true;
    gpg-agent.enable = true;
  };


  xsession.windowManager.i3.config.keybindings = {
          "Mod4+Return" = "exec i3-sensible-terminal";
          "Mod4+Shift+q" = "kill";
          "Mod4+d" = "exec ${pkgs.dmenu}/bin/dmenu_run";

          "Mod4+Left" = "focus left";
          "Mod4+Down" = "focus down";
          "Mod4+Up" = "focus up";
          "Mod4+Right" = "focus right";

          "Mod4+h" = "split h";
          "Mod4+v" = "split v";
          "Mod4+f" = "fullscreen toggle";

          "Mod4+s" = "layout stacking";
          "Mod4+w" = "layout tabbed";
          "Mod4+e" = "layout toggle split";

          "Mod4+Shift+space" = "floating toggle";

          "Mod4+1" = "workspace 1";
          "Mod4+2" = "workspace 2";
          "Mod4+3" = "workspace 3";
          "Mod4+4" = "workspace 4";
          "Mod4+5" = "workspace 5";
          "Mod4+6" = "workspace 6";
          "Mod4+7" = "workspace 7";
          "Mod4+8" = "workspace 8";
          "Mod4+9" = "workspace 9";

          "Mod4+Shift+1" = "move container to workspace 1";
          "Mod4+Shift+2" = "move container to workspace 2";
          "Mod4+Shift+3" = "move container to workspace 3";
          "Mod4+Shift+4" = "move container to workspace 4";
          "Mod4+Shift+5" = "move container to workspace 5";
          "Mod4+Shift+6" = "move container to workspace 6";
          "Mod4+Shift+7" = "move container to workspace 7";
          "Mod4+Shift+8" = "move container to workspace 8";
          "Mod4+Shift+9" = "move container to workspace 9";

          "Mod4+Shift+c" = "reload";
          "Mod4+Shift+r" = "restart";
          "Mod4+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

          "Mod4+r" = "mode resize";
        };

  xsession.windowManager.i3.extraConfig = with pkgs; ''
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
    bindsym XF86WLAN exec $(${rfkill}/bin/rfkill list wlan | grep -e 'Soft blocked: yes' > /dev/null && ${rfkill}/bin/rfkill block wlan) || ${rfkill}/bin/rfkill unblock wlan
    bindsym XF86Calculator exec ${i3lock}/bin/i3lock

    bindsym Print exec ${scrot}/bin/scrot

    exec xrandr --output DP-1 --mode 1920x1080 --left-of DVI-I-1
    exec dropboxd &
    exec xss-lock -v -- i3lock -n &
    exec xautolock -locker i3lock -time 5 -detectsleep &
    exec lxsession &
    #exec autocutsel -fork &
    #exec autocutsel -selection PRIMARY -fork &
    exec QSyncthingTray &
    '';

  xsession.windowManager.i3.config.fonts = [ "DejaVu Sans Mono 10" ];

}

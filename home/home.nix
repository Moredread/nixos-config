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
    evince
    love
    minecraft
    mplayer
    mpv
    paperkey
    python3Packages.mps-youtube
    sloccount
    subversion
    nixops
    vlc
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
  xsession.windowManager.command = "${pkgs.i3}/bin/i3";

  #services.blueman-applet.enable = true;
  #services.keepassx.enable = true;
  #services.network-manager-applet.enable = true;

}

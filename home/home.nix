{ pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in {
  home.packages = with pkgs; [
    apg
    blender
    borgbackup
    calibre
    evince
    love
    minecraft
    mplayer
    mpv
    unstable.nixops
    paperkey
    python3Packages.mps-youtube
    sloccount
    subversion
    youtube-dl
    yubioath-desktop
    vlc
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

  #services.blueman-applet.enable = true;
  #services.keepassx.enable = true;
  #services.network-manager-applet.enable = true;

}

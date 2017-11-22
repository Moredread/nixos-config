{ pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in {
  imports = [
    configs/wm.nix
  ];

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
    xorg.xvinfo
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
}

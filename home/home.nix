{ pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
  local = import /home/addy/nixpkgs {};
in {
  imports = [
    configs/wm.nix
  ];

  home.packages = with pkgs; [
    #steam
    apg
    atool
    blender
    borgbackup
    calibre
    daemontools
    evince
    kate
    kget
    krename
    krusader
    local.electrum
    love
    minecraft
    mplayer
    mpv
    nixops
    nixops
    paperkey
    python36Packages.virtualenv
    python3Packages.mps-youtube
    skype
    sloccount
    subversion
    thunderbird
    unrar
    unzip
    vlc
    xorg.xvinfo
    youtube-dl
    yubioath-desktop
    zip
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

{ pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
  electrum3 = pkgs.callPackage ./pkgs/electrum3.nix {};
in {
  imports = [
    configs/wm.nix
  ];

  home.keyboard.layout = "de";
  home.language = {
    paper = "de";
    monetary = "de";
    address = "de";
  };

  home.packages = with pkgs; [
    apg
    atool
    bind.dnsutils
    blender
    borgbackup
    electrum3
    calibre
    daemontools
    evince
    kate
    kget
    krename
    krusader
    love
    minecraft
    mplayer
    mpv
    nixops
    paperkey
    python36Packages.virtualenv
    python3Packages.mps-youtube
    skype
    sloccount
    subversion
    spotify
    thunderbird
    unrar
    ripgrep
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
    neovim.enable = true;
  };
}
